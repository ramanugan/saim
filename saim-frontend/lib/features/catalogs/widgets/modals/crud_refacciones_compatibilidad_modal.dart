import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/refaccion_compatibilidad.dart';
import '../../providers/refacciones_compatibilidad_provider.dart';

class CrudRefaccionesCompatibilidadModal extends ConsumerStatefulWidget {
  const CrudRefaccionesCompatibilidadModal({super.key});

  @override
  ConsumerState<CrudRefaccionesCompatibilidadModal> createState() => _CrudRefaccionesCompatibilidadModalState();
}

class _CrudRefaccionesCompatibilidadModalState extends ConsumerState<CrudRefaccionesCompatibilidadModal> {
  bool _isEditing = false;
  RefaccionCompatibilidad? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedRefaccionId;
  int? _selectedTipoEquipoId;
  late TextEditingController _marcaEquipoCtrl;
  late TextEditingController _modeloEquipoCtrl;
  String _selectedNivelCompatibilidad = 'TOTAL';
  late TextEditingController _observacionCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedRefaccionId = _selectedItem?.idRefaccion;
    _selectedTipoEquipoId = _selectedItem?.idTipoEquipo;
    _marcaEquipoCtrl = TextEditingController(text: _selectedItem?.marcaEquipo ?? '');
    _modeloEquipoCtrl = TextEditingController(text: _selectedItem?.modeloEquipo ?? '');
    _selectedNivelCompatibilidad = _selectedItem?.nivelCompatibilidad ?? 'TOTAL';
    _observacionCtrl = TextEditingController(text: _selectedItem?.observacion ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _marcaEquipoCtrl.dispose();
    _modeloEquipoCtrl.dispose();
    _observacionCtrl.dispose();
    super.dispose();
  }

  void _openForm([RefaccionCompatibilidad? item]) {
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

    final item = RefaccionCompatibilidad(
      idCompatibilidad: _selectedItem?.idCompatibilidad,
      idRefaccion: _selectedRefaccionId!,
      idTipoEquipo: _selectedTipoEquipoId,
      marcaEquipo: _marcaEquipoCtrl.text.trim().isEmpty ? null : _marcaEquipoCtrl.text.trim(),
      modeloEquipo: _modeloEquipoCtrl.text.trim().isEmpty ? null : _modeloEquipoCtrl.text.trim(),
      nivelCompatibilidad: _selectedNivelCompatibilidad,
      observacion: _observacionCtrl.text.trim().isEmpty ? null : _observacionCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(refaccionesCompatibilidadProvider.notifier).addCompatibilidad(item);
      } else {
        await ref.read(refaccionesCompatibilidadProvider.notifier).updateCompatibilidad(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(RefaccionCompatibilidad item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Compatibilidad'),
        content: Text('¿Estás seguro de que deseas $action este registro de compatibilidad?'),
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

    if (confirm == true && item.idCompatibilidad != null) {
      try {
        await ref.read(refaccionesCompatibilidadProvider.notifier).toggleStatus(item.idCompatibilidad!, item.activo);
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
                        ? (_selectedItem == null ? 'Nueva Compatibilidad' : 'Editar Compatibilidad')
                        : 'Compatibilidad de Refacciones',
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
                          label: const Text('Agregar Compatibilidad'),
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
    final listAsync = ref.watch(refaccionesCompatibilidadProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForCompatibilidadProvider);
    final tiposEquipoAsync = ref.watch(helperTiposEquipoForCompatibilidadProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de compatibilidad.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final refaccionesMap = {
          for (var item in refaccionesAsync.value ?? [])
            item['id_refaccion'] as int: '[${item['codigo_interno']}] ${item['descripcion_homologada']}'
        };

        final tiposEquipoMap = {
          for (var item in tiposEquipoAsync.value ?? [])
            item['id_tipo_equipo'] as int: item['nombre'] as String
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('TIPO EQUIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MARCA EQUIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MODELO EQUIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('NIVEL', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idCompatibilidad.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(refaccionesMap[item.idRefaccion] ?? 'ID: ${item.idRefaccion}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(tiposEquipoMap[item.idTipoEquipo] ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.marcaEquipo ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.modeloEquipo ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.nivelCompatibilidad, style: TextStyle(color: context.textColor))),
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    final refaccionesAsync = ref.watch(helperRefaccionesForCompatibilidadProvider);
    final tiposEquipoAsync = ref.watch(helperTiposEquipoForCompatibilidadProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Refacción & Tipo Equipo
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
                        Text('Tipo Equipo (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedTipoEquipoId,
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
                            const DropdownMenuItem<int?>(value: null, child: Text('Seleccione Tipo Equipo')),
                            ...(tiposEquipoAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              return DropdownMenuItem<int?>(
                                value: item['id_tipo_equipo'] as int,
                                child: Text(item['nombre'] as String),
                              );
                            }),
                          ],
                          onChanged: (val) => setState(() => _selectedTipoEquipoId = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Marca Equipo & Modelo Equipo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Marca Equipo', _marcaEquipoCtrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Modelo Equipo', _modeloEquipoCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Nivel Compatibilidad & Observación
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nivel Compatibilidad *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedNivelCompatibilidad,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: const [
                            DropdownMenuItem<String>(value: 'TOTAL', child: Text('TOTAL')),
                            DropdownMenuItem<String>(value: 'PARCIAL', child: Text('PARCIAL')),
                            DropdownMenuItem<String>(value: 'EXCLUSIVA', child: Text('EXCLUSIVA')),
                            DropdownMenuItem<String>(value: 'ALTERNATIVO', child: Text('ALTERNATIVO')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedNivelCompatibilidad = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Observación', _observacionCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Switch Activo
              Row(
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
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
