import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/refaccion.dart';
import '../../providers/refacciones_provider.dart';

class CrudRefaccionesModal extends ConsumerStatefulWidget {
  const CrudRefaccionesModal({super.key});

  @override
  ConsumerState<CrudRefaccionesModal> createState() => _CrudRefaccionesModalState();
}

class _CrudRefaccionesModalState extends ConsumerState<CrudRefaccionesModal> {
  bool _isEditing = false;
  Refaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedCategoriaId;
  int? _selectedUnidadId;
  late TextEditingController _codigoCtrl;
  late TextEditingController _descripcionCtrl;
  late TextEditingController _marcaCtrl;
  late TextEditingController _numeroParteCtrl;
  String? _criticidadDefault;
  late TextEditingController _tiempoEntregaCtrl;
  bool _empresaPuedeSuministrar = true;
  late TextEditingController _stockMinimoCtrl;
  late TextEditingController _puntoReordenCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedCategoriaId = _selectedItem?.idCategoriaRefaccion;
    _selectedUnidadId = _selectedItem?.idUnidadMedida;
    _codigoCtrl = TextEditingController(text: _selectedItem?.codigoInterno ?? '');
    _descripcionCtrl = TextEditingController(text: _selectedItem?.descripcionHomologada ?? '');
    _marcaCtrl = TextEditingController(text: _selectedItem?.marca ?? '');
    _numeroParteCtrl = TextEditingController(text: _selectedItem?.numeroParte ?? '');
    _criticidadDefault = _selectedItem?.criticidadDefault;
    _tiempoEntregaCtrl = TextEditingController(text: _selectedItem?.tiempoEntregaDias?.toString() ?? '');
    _empresaPuedeSuministrar = _selectedItem?.empresaPuedeSuministrar ?? true;
    _stockMinimoCtrl = TextEditingController(text: _selectedItem?.stockMinimoDefault.toString() ?? '0.00');
    _puntoReordenCtrl = TextEditingController(text: _selectedItem?.puntoReordenDefault.toString() ?? '0.00');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _descripcionCtrl.dispose();
    _marcaCtrl.dispose();
    _numeroParteCtrl.dispose();
    _tiempoEntregaCtrl.dispose();
    _stockMinimoCtrl.dispose();
    _puntoReordenCtrl.dispose();
    super.dispose();
  }

  void _openForm([Refaccion? item]) {
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
    if (_selectedCategoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Categoría')));
      return;
    }
    if (_selectedUnidadId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Unidad de Medida')));
      return;
    }

    final item = Refaccion(
      idRefaccion: _selectedItem?.idRefaccion,
      idCategoriaRefaccion: _selectedCategoriaId!,
      idUnidadMedida: _selectedUnidadId!,
      codigoInterno: _codigoCtrl.text.trim(),
      descripcionHomologada: _descripcionCtrl.text.trim(),
      marca: _marcaCtrl.text.trim().isEmpty ? null : _marcaCtrl.text.trim(),
      numeroParte: _numeroParteCtrl.text.trim().isEmpty ? null : _numeroParteCtrl.text.trim(),
      criticidadDefault: _criticidadDefault,
      tiempoEntregaDias: int.tryParse(_tiempoEntregaCtrl.text),
      empresaPuedeSuministrar: _empresaPuedeSuministrar,
      stockMinimoDefault: double.tryParse(_stockMinimoCtrl.text) ?? 0.0,
      puntoReordenDefault: double.tryParse(_puntoReordenCtrl.text) ?? 0.0,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(refaccionesProvider.notifier).addRefaccion(item);
      } else {
        await ref.read(refaccionesProvider.notifier).updateRefaccion(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(Refaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Refacción'),
        content: Text('¿Estás seguro de que deseas $action esta refacción?'),
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

    if (confirm == true && item.idRefaccion != null) {
      try {
        await ref.read(refaccionesProvider.notifier).toggleStatus(item.idRefaccion!, item.activo);
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
        constraints: const BoxConstraints(maxWidth: 1000),
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
                        ? (_selectedItem == null ? 'Nueva Refacción' : 'Editar Refacción')
                        : 'Catálogo Maestro de Refacciones',
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
                          label: const Text('Agregar Refacción'),
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
    final listAsync = ref.watch(refaccionesProvider);
    final categoriasAsync = ref.watch(helperCategoriasForRefaccionProvider);
    final unidadesAsync = ref.watch(helperUnidadesForRefaccionProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de refacciones.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final categoriasMap = {
          for (var item in categoriasAsync.value ?? [])
            item['id_categoria_refaccion'] as int: item['nombre'] as String
        };

        final unidadesMap = {
          for (var item in unidadesAsync.value ?? [])
            item['id_unidad_medida'] as int: '${item['nombre']} (${item['simbolo']})'
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CÓDIGO INTERNO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('DESCRIPCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CATEGORÍA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MARCA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('Nº PARTE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('U. MEDIDA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CRITICIDAD', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idRefaccion.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.codigoInterno, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.descripcionHomologada, style: TextStyle(color: context.textColor))),
                  DataCell(Text(categoriasMap[item.idCategoriaRefaccion] ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.marca ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.numeroParte ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(unidadesMap[item.idUnidadMedida] ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.criticidadDefault ?? '-', style: TextStyle(color: context.textColor))),
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
    final categoriasAsync = ref.watch(helperCategoriasForRefaccionProvider);
    final unidadesAsync = ref.watch(helperUnidadesForRefaccionProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Categoria & Unidad Medida
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categoría Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedCategoriaId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (categoriasAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_categoria_refaccion'] as int,
                              child: Text(item['nombre'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedCategoriaId = val),
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
                        Text('Unidad Medida *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedUnidadId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (unidadesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_unidad_medida'] as int,
                              child: Text('${item['nombre']} (${item['simbolo'] ?? ''})'),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedUnidadId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Código Interno & Marca
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Código Interno *', _codigoCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Marca', _marcaCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Número Parte & Criticidad
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Número Parte', _numeroParteCtrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Criticidad Default', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String?>(
                          value: _criticidadDefault,
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
                            DropdownMenuItem<String?>(value: null, child: Text('Ninguna')),
                            DropdownMenuItem<String?>(value: 'ALTA', child: Text('ALTA')),
                            DropdownMenuItem<String?>(value: 'MEDIA', child: Text('MEDIA')),
                            DropdownMenuItem<String?>(value: 'BAJA', child: Text('BAJA')),
                          ],
                          onChanged: (val) => setState(() => _criticidadDefault = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Tiempo Entrega (días) & Stock Mínimo Default
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Tiempo Entrega (Días)', _tiempoEntregaCtrl, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Stock Mínimo Default', _stockMinimoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Punto Reorden Default', _puntoReordenCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 5: Switches
              Row(
                children: [
                  Row(
                    children: [
                      Text('Empresa Puede Suministrar', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Switch(
                        value: _empresaPuedeSuministrar,
                        onChanged: (val) {
                          setState(() {
                            _empresaPuedeSuministrar = val;
                          });
                        },
                        activeColor: AppColors.green,
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
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
