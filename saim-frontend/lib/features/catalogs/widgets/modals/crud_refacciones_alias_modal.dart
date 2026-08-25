import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/refaccion_alias.dart';
import '../../providers/refacciones_alias_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudRefaccionesAliasModal extends ConsumerStatefulWidget {
  const CrudRefaccionesAliasModal({super.key});

  @override
  ConsumerState<CrudRefaccionesAliasModal> createState() => _CrudRefaccionesAliasModalState();
}

class _CrudRefaccionesAliasModalState extends ConsumerState<CrudRefaccionesAliasModal> {
  bool _isEditing = false;
  RefaccionAlias? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedRefaccionId;
  int? _selectedValidadoPorId;
  late TextEditingController _aliasCtrl;
  late TextEditingController _origenCtrl;
  late TextEditingController _confianzaCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedRefaccionId = _selectedItem?.idRefaccion;
    _selectedValidadoPorId = _selectedItem?.validadoPor;
    _aliasCtrl = TextEditingController(text: _selectedItem?.alias ?? '');
    _origenCtrl = TextEditingController(text: _selectedItem?.origen ?? '');
    _confianzaCtrl = TextEditingController(text: _selectedItem?.confianzaMatch?.toString() ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _aliasCtrl.dispose();
    _origenCtrl.dispose();
    _confianzaCtrl.dispose();
    super.dispose();
  }

  void _openForm([RefaccionAlias? item]) {
    setState(() {
      _selectedItem = item;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedItem = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRefaccionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Refacción')));
      return;
    }

    final item = RefaccionAlias(
      idRefaccionAlias: _selectedItem?.idRefaccionAlias,
      idRefaccion: _selectedRefaccionId!,
      validadoPor: _selectedValidadoPorId,
      alias: _aliasCtrl.text.trim(),
      origen: _origenCtrl.text.trim(),
      confianzaMatch: double.tryParse(_confianzaCtrl.text),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(refaccionesAliasProvider.notifier).addAlias(item);
      } else {
        await ref.read(refaccionesAliasProvider.notifier).updateAlias(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(RefaccionAlias item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Alias'),
        content: Text('¿Estás seguro de que deseas $action este alias?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(item.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );

    if (confirm == true && item.idRefaccionAlias != null) {
      try {
        await ref.read(refaccionesAliasProvider.notifier).toggleStatus(item.idRefaccionAlias!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: const BoxConstraints(maxWidth: 900),
        height: 600,
        color: context.surfaceColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing
                        ? (_selectedItem == null ? 'Nuevo Alias' : 'Editar Alias')
                        : 'Alias de Refacciones',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  Row(
                    children: [
                      if (!_isEditing)
                        ElevatedButton.icon(
                          onPressed: () => _openForm(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Agregar Alias'),
                        ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.close, color: context.mutedTextColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(height: 1, color: context.borderColor),
            Expanded(
              child: _isEditing ? _buildForm() : _buildTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    final listAsync = ref.watch(refaccionesAliasProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForAliasProvider);
    final usuariosAsync = ref.watch(helperUsuariosForAliasProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de alias.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final refaccionesMap = {
          for (var item in refaccionesAsync.value ?? [])
            item['id_refaccion'] as int: '[${item['codigo_interno']}] ${item['descripcion_homologada']}'
        };

        final usuariosMap = {
          for (var item in usuariosAsync.value ?? [])
            item['id_usuario'] as int: item['nombre_usuario'] as String
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ALIAS', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ORIGEN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CONFIANZA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('VALIDADO POR', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idRefaccionAlias.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(refaccionesMap[item.idRefaccion] ?? 'ID: ${item.idRefaccion}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.alias, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.origen, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.confianzaMatch != null ? '${item.confianzaMatch!.toStringAsFixed(2)}%' : '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(usuariosMap[item.validadoPor] ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: item.activo ? AppColors.green : AppColors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.blue, size: 20),
                        onPressed: () => _openForm(item),
                      ),
                      IconButton(
                        icon: Icon(item.activo ? Icons.block : Icons.check_circle_outline, color: item.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(item),
                      ),
                    ],
                  )),
                ],
              )).toList(),
            ));
      },
    );
  }

  Widget _buildForm() {
    final refaccionesAsync = ref.watch(helperRefaccionesForAliasProvider);
    final usuariosAsync = ref.watch(helperUsuariosForAliasProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Refacción & Validado Por
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedRefaccionId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (refaccionesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final code = item['codigo_interno'] as String;
                            final name = item['descripcion_homologada'] as String;
                            return DropdownMenuItem<int>(
                              value: item['id_refaccion'] as int,
                              child: Text('[$code] $name', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedRefaccionId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Validado Por (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedValidadoPorId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: [
                            const DropdownMenuItem<int?>(value: null, child: Text('Ninguno')),
                            ...(usuariosAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              return DropdownMenuItem<int?>(
                                value: item['id_usuario'] as int,
                                child: Text(item['nombre_usuario'] as String),
                              );
                            }),
                          ],
                          onChanged: (val) => setState(() => _selectedValidadoPorId = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Alias & Origen
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Alias *', _aliasCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Origen *', _origenCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Confianza Match & Activo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Confianza Match (%)', _confianzaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _activo,
                          onChanged: (val) {
                            setState(() {
                              _activo = val;
                            });
                          },
                          activeColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save & Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _closeForm,
                    style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
          ),
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
