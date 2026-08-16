import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/oportunidad_suministro.dart';
import '../../providers/oportunidades_suministro_provider.dart';

class CrudOportunidadSuministroModal extends ConsumerStatefulWidget {
  const CrudOportunidadSuministroModal({super.key});

  @override
  ConsumerState<CrudOportunidadSuministroModal> createState() => _CrudOportunidadSuministroModalState();
}

class _CrudOportunidadSuministroModalState extends ConsumerState<CrudOportunidadSuministroModal> {
  bool _isEditing = false;
  OportunidadSuministro? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedSolicitudDetalleId;
  int? _selectedCotizacionId;
  late TextEditingController _fechaDeteccionCtrl;
  late TextEditingController _motivoCtrl;
  late TextEditingController _cantidadCtrl;
  late TextEditingController _montoCtrl;
  String _selectedEstado = 'PENDIENTE';
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedSolicitudDetalleId = _selectedItem?.idSolicitudRefaccionDetalle;
    _selectedCotizacionId = _selectedItem?.idCotizacion;
    _fechaDeteccionCtrl = TextEditingController(
      text: _selectedItem != null
          ? _selectedItem!.fechaDeteccion.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first,
    );
    _motivoCtrl = TextEditingController(text: _selectedItem?.motivo ?? '');
    _cantidadCtrl = TextEditingController(text: _selectedItem?.cantidadOfertable.toString() ?? '');
    _montoCtrl = TextEditingController(text: _selectedItem?.montoEstimado?.toString() ?? '');
    _selectedEstado = _selectedItem?.estado ?? 'PENDIENTE';
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _fechaDeteccionCtrl.dispose();
    _motivoCtrl.dispose();
    _cantidadCtrl.dispose();
    _montoCtrl.dispose();
    super.dispose();
  }

  void _openForm([OportunidadSuministro? item]) {
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
    if (_selectedSolicitudDetalleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Partida Solicitada')));
      return;
    }

    final cant = double.tryParse(_cantidadCtrl.text) ?? 0.0;
    final monto = double.tryParse(_montoCtrl.text);

    final item = OportunidadSuministro(
      idOportunidad: _selectedItem?.idOportunidad,
      idSolicitudRefaccionDetalle: _selectedSolicitudDetalleId!,
      idCotizacion: _selectedCotizacionId,
      fechaDeteccion: DateTime.parse(_fechaDeteccionCtrl.text),
      motivo: _motivoCtrl.text.trim(),
      cantidadOfertable: cant,
      montoEstimado: monto,
      estado: _selectedEstado,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(oportunidadesSuministroProvider.notifier).addOportunidad(item);
      } else {
        await ref.read(oportunidadesSuministroProvider.notifier).updateOportunidad(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(OportunidadSuministro item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Oportunidad'),
        content: Text('¿Estás seguro de que deseas $action esta oportunidad comercial?'),
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

    if (confirm == true && item.idOportunidad != null) {
      try {
        await ref.read(oportunidadesSuministroProvider.notifier).toggleStatus(item.idOportunidad!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _selectDate() async {
    final initialDate = DateTime.tryParse(_fechaDeteccionCtrl.text) ?? DateTime.now();

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
        _fechaDeteccionCtrl.text = pickedDate.toIso8601String().split('T').first;
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
                        ? (_selectedItem == null ? 'Nueva Oportunidad' : 'Editar Oportunidad')
                        : 'Oportunidades de Suministro',
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
                          label: const Text('Registrar Oportunidad'),
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
    final listAsync = ref.watch(oportunidadesSuministroProvider);
    final solicitudDetallesAsync = ref.watch(helperSolicitudDetallesForOportunidadProvider);
    final cotizacionesAsync = ref.watch(helperCotizacionesForOportunidadProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay oportunidades comerciales registradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final solicitudDetallesMap = {
          for (var item in solicitudDetallesAsync.value ?? [])
            item['id_solicitud_refaccion_detalle'] as int: () {
              final refObj = item['refaccion'] as Map<String, dynamic>?;
              final code = refObj?['codigo_interno'] ?? 'S/C';
              final desc = refObj?['descripcion_homologada'] ?? 'S/D';
              return '[$code] $desc (Sol: ${item['cantidad_solicitada']})';
            }()
        };

        final cotizacionesMap = {
          for (var item in cotizacionesAsync.value ?? [])
            item['id_cotizacion'] as int: item['numero_cotizacion'] as String
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN SOLICITADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FECHA DETECCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MOTIVO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. OFERTABLE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MONTO ESTIMADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('COTIZACIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idOportunidad.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(solicitudDetallesMap[item.idSolicitudRefaccionDetalle] ?? 'Detalle ID: ${item.idSolicitudRefaccionDetalle}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaDeteccion.toLocal().toString().split(' ').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.motivo, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadOfertable.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.montoEstimado != null ? '\$${item.montoEstimado!.toStringAsFixed(2)}' : '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.idCotizacion != null ? (cotizacionesMap[item.idCotizacion] ?? 'Cot ID: ${item.idCotizacion}') : '-', style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.estado,
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
    final solicitudDetallesAsync = ref.watch(helperSolicitudDetallesForOportunidadProvider);
    final cotizacionesAsync = ref.watch(helperCotizacionesForOportunidadProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Solicitud Detalle & Cotizacion
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Partida Solicitada *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedSolicitudDetalleId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (solicitudDetallesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final refObj = item['refaccion'] as Map<String, dynamic>?;
                            final code = refObj?['codigo_interno'] ?? 'S/C';
                            final desc = refObj?['descripcion_homologada'] ?? 'S/D';
                            final qty = item['cantidad_solicitada'];
                            return DropdownMenuItem<int>(
                              value: item['id_solicitud_refaccion_detalle'] as int,
                              child: Text('[$code] $desc (Sol: $qty)', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedSolicitudDetalleId = val),
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
                        Text('Cotización Vinculada (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedCotizacionId,
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
                            const DropdownMenuItem<int?>(value: null, child: Text('Ninguna')),
                            ...(cotizacionesAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              return DropdownMenuItem<int?>(
                                value: item['id_cotizacion'] as int,
                                child: Text(item['numero_cotizacion'] as String),
                              );
                            }),
                          ],
                          onChanged: (val) => setState(() => _selectedCotizacionId = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Fecha Deteccion & Estado
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha de Detección *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fechaDeteccionCtrl,
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
                          onTap: _selectDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado Oportunidad *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedEstado,
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
                            DropdownMenuItem<String>(value: 'PENDIENTE', child: Text('PENDIENTE')),
                            DropdownMenuItem<String>(value: 'COTIZADO', child: Text('COTIZADO')),
                            DropdownMenuItem<String>(value: 'SUMINISTRADO', child: Text('SUMINISTRADO')),
                            DropdownMenuItem<String>(value: 'CANCELADO', child: Text('CANCELADO')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedEstado = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Cantidad Ofertable & Monto Estimado
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Cantidad Ofertable *', _cantidadCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Monto Estimado', _montoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Motivo & Activo
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField('Motivo / Comentarios *', _motivoCtrl, required: true),
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
