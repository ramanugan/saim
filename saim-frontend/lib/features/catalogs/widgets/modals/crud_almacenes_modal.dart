import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/almacen.dart';
import '../../providers/almacenes_provider.dart';
import '../../providers/estados_provider.dart';
import '../../providers/municipios_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudAlmacenesModal extends ConsumerStatefulWidget {
  const CrudAlmacenesModal({super.key});

  @override
  ConsumerState<CrudAlmacenesModal> createState() => _CrudAlmacenesModalState();
}

class _CrudAlmacenesModalState extends ConsumerState<CrudAlmacenesModal> {
  bool _isEditing = false;
  Almacen? _selectedAlmacen;

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _direccionCtrl;
  int? _selectedEstadoId;
  int? _selectedMunicipioId;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoCtrl = TextEditingController(text: _selectedAlmacen?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: _selectedAlmacen?.nombre ?? '');
    _direccionCtrl = TextEditingController(text: _selectedAlmacen?.direccion ?? '');
    _selectedEstadoId = _selectedAlmacen?.idEstado;
    _selectedMunicipioId = _selectedAlmacen?.idMunicipio;
    _activo = _selectedAlmacen?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  void _openForm([Almacen? almacen]) {
    setState(() {
      _selectedAlmacen = almacen;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedAlmacen = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final almacen = Almacen(
      idAlmacen: _selectedAlmacen?.idAlmacen,
      idEstado: _selectedEstadoId,
      idMunicipio: _selectedMunicipioId,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedAlmacen == null) {
        await ref.read(almacenesProvider.notifier).addAlmacen(almacen);
      } else {
        await ref.read(almacenesProvider.notifier).updateAlmacen(almacen);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(Almacen almacen) async {
    final action = almacen.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${almacen.activo ? 'Desactivar' : 'Activar'} Almacén'),
        content: Text('¿Estás seguro de que deseas $action este almacén?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(almacen.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );

    if (confirm == true && almacen.idAlmacen != null) {
      try {
        await ref.read(almacenesProvider.notifier).toggleStatus(almacen.idAlmacen!, almacen.activo);
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
        constraints: const BoxConstraints(maxWidth: 800),
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
                        ? (_selectedAlmacen == null ? 'Nuevo Almacén' : 'Editar Almacén')
                        : 'Gestión de Almacenes',
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
                          label: const Text('Agregar Almacén'),
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
    final listAsync = ref.watch(almacenesProvider);
    final estadosAsync = ref.watch(estadosProvider);
    final municipiosAsync = ref.watch(municipiosProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de almacenes.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final estadosMap = {
          for (var item in estadosAsync.value ?? [])
            item.idEstado as int: item.nombre
        };

        final municipiosMap = {
          for (var item in municipiosAsync.value ?? [])
            item.idMunicipio as int: item.nombre
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MUNICIPIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO REGISTRO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idAlmacen.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.codigo, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.nombre, style: TextStyle(color: context.textColor))),
                  DataCell(Text(estadosMap[item.idEstado] ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(municipiosMap[item.idMunicipio] ?? '-', style: TextStyle(color: context.textColor))),
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
    final estadosAsync = ref.watch(estadosProvider);
    final municipiosAsync = ref.watch(municipiosProvider);

    final filteredMunicipios = (municipiosAsync.value ?? [])
        .where((m) => _selectedEstadoId == null || m.idEstado == _selectedEstadoId)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Código & Nombre
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Código *', _codigoCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Nombre *', _nombreCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Estado & Municipio (Filtrado)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedEstadoId,
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
                            const DropdownMenuItem<int?>(value: null, child: Text('Seleccione Estado')),
                            ...(estadosAsync.value ?? []).map((e) => DropdownMenuItem<int?>(
                              value: e.idEstado,
                              child: Text(e.nombre),
                            )),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedEstadoId = val;
                              _selectedMunicipioId = null; // Reset municipio selection when state changes
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Municipio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedMunicipioId,
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
                            const DropdownMenuItem<int?>(value: null, child: Text('Seleccione Municipio')),
                            ...filteredMunicipios.map((m) => DropdownMenuItem<int?>(
                              value: m.idMunicipio,
                              child: Text(m.nombre),
                            )),
                          ],
                          onChanged: (val) => setState(() => _selectedMunicipioId = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Multiline text: Dirección
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dirección', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _direccionCtrl,
                    maxLines: 2,
                    maxLength: 255,
                    style: TextStyle(color: context.textColor),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: context.backgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
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
