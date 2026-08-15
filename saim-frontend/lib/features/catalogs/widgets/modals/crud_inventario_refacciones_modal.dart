import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/inventario_refaccion.dart';
import '../../providers/inventarios_refaccion_provider.dart';

class CrudInventarioRefaccionesModal extends ConsumerStatefulWidget {
  const CrudInventarioRefaccionesModal({super.key});

  @override
  ConsumerState<CrudInventarioRefaccionesModal> createState() => _CrudInventarioRefaccionesModalState();
}

class _CrudInventarioRefaccionesModalState extends ConsumerState<CrudInventarioRefaccionesModal> {
  bool _isEditing = false;
  InventarioRefaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedAlmacenId;
  int? _selectedRefaccionId;
  late TextEditingController _existenciaCtrl;
  late TextEditingController _reservadoCtrl;
  late TextEditingController _stockMinimoCtrl;
  late TextEditingController _puntoReordenCtrl;
  late TextEditingController _fechaUltimoConteoCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedAlmacenId = _selectedItem?.idAlmacen;
    _selectedRefaccionId = _selectedItem?.idRefaccion;
    _existenciaCtrl = TextEditingController(text: _selectedItem?.existencia.toString() ?? '0.00');
    _reservadoCtrl = TextEditingController(text: _selectedItem?.reservado.toString() ?? '0.00');
    _stockMinimoCtrl = TextEditingController(text: _selectedItem?.stockMinimo.toString() ?? '0.00');
    _puntoReordenCtrl = TextEditingController(text: _selectedItem?.puntoReorden.toString() ?? '0.00');
    _fechaUltimoConteoCtrl = TextEditingController(
      text: _selectedItem?.fechaUltimoConteo?.toIso8601String().split('T').first ?? '',
    );
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _existenciaCtrl.dispose();
    _reservadoCtrl.dispose();
    _stockMinimoCtrl.dispose();
    _puntoReordenCtrl.dispose();
    _fechaUltimoConteoCtrl.dispose();
    super.dispose();
  }

  void _openForm([InventarioRefaccion? item]) {
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
    if (_selectedAlmacenId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un Almacén')));
      return;
    }
    if (_selectedRefaccionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Refacción')));
      return;
    }

    final item = InventarioRefaccion(
      idInventario: _selectedItem?.idInventario,
      idAlmacen: _selectedAlmacenId!,
      idRefaccion: _selectedRefaccionId!,
      existencia: double.tryParse(_existenciaCtrl.text) ?? 0.0,
      reservado: double.tryParse(_reservadoCtrl.text) ?? 0.0,
      stockMinimo: double.tryParse(_stockMinimoCtrl.text) ?? 0.0,
      puntoReorden: double.tryParse(_puntoReordenCtrl.text) ?? 0.0,
      fechaUltimoConteo: _fechaUltimoConteoCtrl.text.isNotEmpty ? DateTime.parse(_fechaUltimoConteoCtrl.text) : null,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(inventariosRefaccionProvider.notifier).addInventario(item);
      } else {
        await ref.read(inventariosRefaccionProvider.notifier).updateInventario(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(InventarioRefaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Stock de Refacción'),
        content: Text('¿Estás seguro de que deseas $action este registro de inventario?'),
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

    if (confirm == true && item.idInventario != null) {
      try {
        await ref.read(inventariosRefaccionProvider.notifier).toggleStatus(item.idInventario!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _selectFechaUltimoConteo() async {
    final initialDate = _fechaUltimoConteoCtrl.text.isNotEmpty
        ? DateTime.tryParse(_fechaUltimoConteoCtrl.text) ?? DateTime.now()
        : DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              surface: context.surfaceColor,
              onSurface: context.textColor,
            ),
            dialogBackgroundColor: context.surfaceColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _fechaUltimoConteoCtrl.text = pickedDate.toIso8601String().split('T').first;
      });
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
                        ? (_selectedItem == null ? 'Nuevo Registro de Stock' : 'Editar Registro de Stock')
                        : 'Inventario de Refacciones por Almacén',
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
                          label: const Text('Agregar Stock'),
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
    final listAsync = ref.watch(inventariosRefaccionProvider);
    final almacenesAsync = ref.watch(helperAlmacenesForInventarioProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForInventarioProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de inventario de refacciones.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final almacenesMap = {
          for (var item in almacenesAsync.value ?? [])
            item['id_almacen'] as int: item['nombre'] as String
        };

        final refaccionesMap = {
          for (var item in refaccionesAsync.value ?? [])
            item['id_refaccion'] as int: '[${item['codigo_interno']}] ${item['descripcion_homologada']}'
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ALMACÉN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('EXISTENCIA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('RESERVADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('DISPONIBLE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('STOCK MÍNIMO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PUNTO REORDEN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ÚLTIMO CONTEO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idInventario.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(almacenesMap[item.idAlmacen] ?? 'ID: ${item.idAlmacen}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(refaccionesMap[item.idRefaccion] ?? 'ID: ${item.idRefaccion}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.existencia.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.reservado.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(
                    item.disponible?.toStringAsFixed(2) ?? '-',
                    style: TextStyle(
                      color: (item.disponible ?? 0) <= item.stockMinimo ? AppColors.red : AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataCell(Text(item.stockMinimo.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.puntoReorden.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaUltimoConteo != null ? item.fechaUltimoConteo!.toIso8601String().split('T').first : '-', style: TextStyle(color: context.textColor))),
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
    final almacenesAsync = ref.watch(helperAlmacenesForInventarioProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForInventarioProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Almacén & Refacción
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Almacén *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedAlmacenId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (almacenesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_almacen'] as int,
                              child: Text(item['nombre'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedAlmacenId = val),
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
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Existencia, Reservado, Stock Mínimo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Existencia *', _existenciaCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Reservado *', _reservadoCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Stock Mínimo *', _stockMinimoCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Punto Reorden & Fecha Último Conteo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Punto Reorden *', _puntoReordenCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha Último Conteo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fechaUltimoConteoCtrl,
                          readOnly: true,
                          style: TextStyle(color: context.textColor),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            suffixIcon: Icon(Icons.calendar_today, color: context.mutedTextColor, size: 18),
                          ),
                          onTap: _selectFechaUltimoConteo,
                        ),
                      ],
                    ),
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
