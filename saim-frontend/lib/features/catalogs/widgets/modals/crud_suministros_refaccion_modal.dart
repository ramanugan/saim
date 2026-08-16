import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/suministro_refaccion.dart';
import '../../providers/suministros_refaccion_provider.dart';

class CrudSuministrosRefaccionModal extends ConsumerStatefulWidget {
  const CrudSuministrosRefaccionModal({super.key});

  @override
  ConsumerState<CrudSuministrosRefaccionModal> createState() => _CrudSuministrosRefaccionModalState();
}

class _CrudSuministrosRefaccionModalState extends ConsumerState<CrudSuministrosRefaccionModal> {
  bool _isEditing = false;
  SuministroRefaccion? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedSolicitudId;
  String _selectedFuenteSuministro = 'CLIENTE';
  int? _selectedProveedorId;
  int? _selectedAlmacenId;
  late TextEditingController _fechaSuministroCtrl;
  late TextEditingController _documentoReferenciaCtrl;
  late TextEditingController _recibidoPorCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedSolicitudId = _selectedItem?.idSolicitudRefaccion;
    
    String rawSource = _selectedItem?.fuenteSuministro ?? 'CLIENTE';
    if (rawSource == 'PROVEEDOR') {
      rawSource = 'PROVEEDOR CLIENTE';
    } else if (rawSource == 'ALMACÉN') {
      rawSource = 'ALMACEN LOCAL';
    }
    
    const validFuentes = {'CLIENTE', 'PROVEEDOR CLIENTE', 'EMPRESA', 'TERCERO', 'ALMACEN LOCAL'};
    _selectedFuenteSuministro = validFuentes.contains(rawSource) ? rawSource : 'CLIENTE';
    
    _selectedProveedorId = _selectedItem?.idProveedor;
    _selectedAlmacenId = _selectedItem?.idAlmacen;
    _fechaSuministroCtrl = TextEditingController(
      text: _selectedItem != null
          ? _selectedItem!.fechaSuministro.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    _documentoReferenciaCtrl = TextEditingController(text: _selectedItem?.documentoReferencia ?? '');
    _recibidoPorCtrl = TextEditingController(text: _selectedItem?.recibidoPor ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _fechaSuministroCtrl.dispose();
    _documentoReferenciaCtrl.dispose();
    _recibidoPorCtrl.dispose();
    super.dispose();
  }

  void _openForm([SuministroRefaccion? item]) {
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
    if (_selectedSolicitudId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Solicitud')));
      return;
    }

    final item = SuministroRefaccion(
      idSuministro: _selectedItem?.idSuministro,
      idSolicitudRefaccion: _selectedSolicitudId!,
      fuenteSuministro: _selectedFuenteSuministro,
      idProveedor: _selectedFuenteSuministro == 'PROVEEDOR CLIENTE' ? _selectedProveedorId : null,
      idAlmacen: _selectedFuenteSuministro == 'ALMACEN LOCAL' ? _selectedAlmacenId : null,
      fechaSuministro: DateTime.parse(_fechaSuministroCtrl.text),
      documentoReferencia: _documentoReferenciaCtrl.text.trim().isEmpty ? null : _documentoReferenciaCtrl.text.trim(),
      recibidoPor: _recibidoPorCtrl.text.trim().isEmpty ? null : _recibidoPorCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(suministrosRefaccionProvider.notifier).addSuministro(item);
      } else {
        await ref.read(suministrosRefaccionProvider.notifier).updateSuministro(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(SuministroRefaccion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Suministro'),
        content: Text('¿Estás seguro de que deseas $action este registro de suministro?'),
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

    if (confirm == true && item.idSuministro != null) {
      try {
        await ref.read(suministrosRefaccionProvider.notifier).toggleStatus(item.idSuministro!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _selectFechaSuministro() async {
    final initialDate = DateTime.tryParse(_fechaSuministroCtrl.text) ?? DateTime.now();

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
        _fechaSuministroCtrl.text = pickedDate.toIso8601String().split('T').first;
      });
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
                        ? (_selectedItem == null ? 'Registrar Suministro' : 'Editar Suministro')
                        : 'Suministro de Refacciones',
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
                          label: const Text('Registrar Suministro'),
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
    final listAsync = ref.watch(suministrosRefaccionProvider);
    final solicitudesAsync = ref.watch(helperSolicitudesForSuministroProvider);
    final proveedoresAsync = ref.watch(helperProveedoresForSuministroProvider);
    final almacenesAsync = ref.watch(helperAlmacenesForSuministroProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de suministros.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final solicitudesMap = {
          for (var item in solicitudesAsync.value ?? [])
            item['id_solicitud_refaccion'] as int: item['folio'] as String
        };

        final proveedoresMap = {
          for (var item in proveedoresAsync.value ?? [])
            item['id_provider'] as int? ?? item['id_proveedor'] as int: item['razon_social'] as String
        };

        final almacenesMap = {
          for (var item in almacenesAsync.value ?? [])
            item['id_almacen'] as int: item['nombre'] as String
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FOLIO SOLICITUD', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FUENTE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PROVEEDOR/ALMACÉN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FECHA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('DOC. REFERENCIA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('RECIBIDO POR', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) {
                String dynamicSource = '-';
                if (item.fuenteSuministro == 'PROVEEDOR CLIENTE') {
                  dynamicSource = proveedoresMap[item.idProveedor] ?? 'Prov ID: ${item.idProveedor}';
                } else if (item.fuenteSuministro == 'ALMACEN LOCAL') {
                  dynamicSource = almacenesMap[item.idAlmacen] ?? 'Alm ID: ${item.idAlmacen}';
                }

                return DataRow(
                  cells: [
                    DataCell(Text(item.idSuministro.toString(), style: TextStyle(color: context.textColor))),
                    DataCell(Text(solicitudesMap[item.idSolicitudRefaccion] ?? 'ID: ${item.idSolicitudRefaccion}', style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.fuenteSuministro, style: TextStyle(color: context.textColor))),
                    DataCell(Text(dynamicSource, style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.fechaSuministro.toLocal().toString().split(' ').first, style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.documentoReferencia ?? '-', style: TextStyle(color: context.textColor))),
                    DataCell(Text(item.recibidoPor ?? '-', style: TextStyle(color: context.textColor))),
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
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    final solicitudesAsync = ref.watch(helperSolicitudesForSuministroProvider);
    final proveedoresAsync = ref.watch(helperProveedoresForSuministroProvider);
    final almacenesAsync = ref.watch(helperAlmacenesForSuministroProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Solicitud & Fuente Suministro
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Solicitud Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedSolicitudId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (solicitudesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_solicitud_refaccion'] as int,
                              child: Text(item['folio'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedSolicitudId = val),
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
                        Text('Fuente Suministro *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedFuenteSuministro,
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
                            DropdownMenuItem<String>(value: 'CLIENTE', child: Text('CLIENTE')),
                            DropdownMenuItem<String>(value: 'PROVEEDOR CLIENTE', child: Text('PROVEEDOR CLIENTE')),
                            DropdownMenuItem<String>(value: 'EMPRESA', child: Text('EMPRESA')),
                            DropdownMenuItem<String>(value: 'TERCERO', child: Text('TERCERO')),
                            DropdownMenuItem<String>(value: 'ALMACEN LOCAL', child: Text('ALMACEN LOCAL')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedFuenteSuministro = val;
                                _selectedProveedorId = null;
                                _selectedAlmacenId = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Proveedor (Conditional) OR Almacen (Conditional)
              if (_selectedFuenteSuministro == 'PROVEEDOR CLIENTE')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proveedor *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _selectedProveedorId,
                      style: TextStyle(color: context.textColor),
                      dropdownColor: context.surfaceColor,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: context.backgroundColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                      ),
                      items: (proveedoresAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                        return DropdownMenuItem<int>(
                          value: item['id_proveedor'] as int,
                          child: Text(item['razon_social'] as String),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedProveedorId = val),
                      validator: (val) => val == null ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              if (_selectedFuenteSuministro == 'ALMACEN LOCAL')
                Column(
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
                    const SizedBox(height: 16),
                  ],
                ),

              // Row 3: Fecha Suministro & Documento Referencia
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha Suministro *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fechaSuministroCtrl,
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
                          onTap: _selectFechaSuministro,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Documento Referencia (Factura / Remisión)', _documentoReferenciaCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Recibido Por & Activo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Recibido Por', _recibidoPorCtrl),
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
