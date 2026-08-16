import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/solicitud_refaccion_detalle.dart';
import '../../providers/solicitudes_refaccion_detalle_provider.dart';

class CrudSolicitudRefaccionDetalleModal extends ConsumerStatefulWidget {
  const CrudSolicitudRefaccionDetalleModal({super.key});

  @override
  ConsumerState<CrudSolicitudRefaccionDetalleModal> createState() => _CrudSolicitudRefaccionDetalleModalState();
}

class _CrudSolicitudRefaccionDetalleModalState extends ConsumerState<CrudSolicitudRefaccionDetalleModal> {
  bool _isEditing = false;
  SolicitudRefaccionDetalle? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedSolicitudId;
  int? _selectedRefaccionId;
  int? _selectedEquipoId;
  late TextEditingController _descOriginalCtrl;
  late TextEditingController _cantNecesariaCtrl;
  late TextEditingController _cantSolicitadaCtrl;
  late TextEditingController _cantAutorizadaCtrl;
  late TextEditingController _cantPedidaCtrl;
  late TextEditingController _cantSuministradaCtrl;
  late TextEditingController _cantInstaladaCtrl;
  late TextEditingController _cantCanceladaCtrl;
  late TextEditingController _fechaRequeridaCtrl;
  String? _selectedCriticidad;
  late TextEditingController _afectacionCtrl;
  String _selectedEstado = 'PENDIENTE';
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedSolicitudId = _selectedItem?.idSolicitudRefaccion;
    _selectedRefaccionId = _selectedItem?.idRefaccion;
    _selectedEquipoId = _selectedItem?.idEquipo;
    _descOriginalCtrl = TextEditingController(text: _selectedItem?.descripcionOriginal ?? '');
    _cantNecesariaCtrl = TextEditingController(text: _selectedItem?.cantidadNecesaria.toString() ?? '');
    _cantSolicitadaCtrl = TextEditingController(text: _selectedItem?.cantidadSolicitada.toString() ?? '');
    _cantAutorizadaCtrl = TextEditingController(text: _selectedItem?.cantidadAutorizada.toString() ?? '0.0');
    _cantPedidaCtrl = TextEditingController(text: _selectedItem?.cantidadPedida.toString() ?? '0.0');
    _cantSuministradaCtrl = TextEditingController(text: _selectedItem?.cantidadSuministrada.toString() ?? '0.0');
    _cantInstaladaCtrl = TextEditingController(text: _selectedItem?.cantidadInstalada.toString() ?? '0.0');
    _cantCanceladaCtrl = TextEditingController(text: _selectedItem?.cantidadCancelada.toString() ?? '0.0');
    _fechaRequeridaCtrl = TextEditingController(
      text: _selectedItem?.fechaRequerida != null
          ? _selectedItem!.fechaRequerida!.toIso8601String().split('T').first
          : '',
    );
    _selectedCriticidad = _selectedItem?.criticidad;
    _afectacionCtrl = TextEditingController(text: _selectedItem?.afectacionOperativaPct?.toString() ?? '');
    _selectedEstado = _selectedItem?.estado ?? 'PENDIENTE';
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _descOriginalCtrl.dispose();
    _cantNecesariaCtrl.dispose();
    _cantSolicitadaCtrl.dispose();
    _cantAutorizadaCtrl.dispose();
    _cantPedidaCtrl.dispose();
    _cantSuministradaCtrl.dispose();
    _cantInstaladaCtrl.dispose();
    _cantCanceladaCtrl.dispose();
    _fechaRequeridaCtrl.dispose();
    _afectacionCtrl.dispose();
    super.dispose();
  }

  void _openForm([SolicitudRefaccionDetalle? item]) {
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

    final nec = double.tryParse(_cantNecesariaCtrl.text) ?? 0.0;
    final sol = double.tryParse(_cantSolicitadaCtrl.text) ?? 0.0;
    final aut = double.tryParse(_cantAutorizadaCtrl.text) ?? 0.0;
    final ped = double.tryParse(_cantPedidaCtrl.text) ?? 0.0;
    final sum = double.tryParse(_cantSuministradaCtrl.text) ?? 0.0;
    final ins = double.tryParse(_cantInstaladaCtrl.text) ?? 0.0;
    final can = double.tryParse(_cantCanceladaCtrl.text) ?? 0.0;
    final afect = double.tryParse(_afectacionCtrl.text);

    final item = SolicitudRefaccionDetalle(
      idSolicitudRefaccionDetalle: _selectedItem?.idSolicitudRefaccionDetalle,
      idSolicitudRefaccion: _selectedSolicitudId!,
      idRefaccion: _selectedRefaccionId,
      idEquipo: _selectedEquipoId,
      descripcionOriginal: _descOriginalCtrl.text.trim(),
      cantidadNecesaria: nec,
      cantidadSolicitada: sol,
      cantidadAutorizada: aut,
      cantidadPedida: ped,
      cantidadSuministrada: sum,
      cantidadInstalada: ins,
      cantidadCancelada: can,
      fechaRequerida: _fechaRequeridaCtrl.text.isEmpty ? null : DateTime.parse(_fechaRequeridaCtrl.text),
      criticidad: _selectedCriticidad,
      afectacionOperativaPct: afect,
      estado: _selectedEstado,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(solicitudesRefaccionDetalleProvider.notifier).addDetalle(item);
      } else {
        await ref.read(solicitudesRefaccionDetalleProvider.notifier).updateDetalle(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(SolicitudRefaccionDetalle item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Partida'),
        content: Text('¿Estás seguro de que deseas $action esta partida de solicitud?'),
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

    if (confirm == true && item.idSolicitudRefaccionDetalle != null) {
      try {
        await ref.read(solicitudesRefaccionDetalleProvider.notifier).toggleStatus(item.idSolicitudRefaccionDetalle!, item.activo);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _selectDate() async {
    final initialDate = DateTime.tryParse(_fechaRequeridaCtrl.text) ?? DateTime.now();

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
        _fechaRequeridaCtrl.text = pickedDate.toIso8601String().split('T').first;
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
        height: 650,
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
                        ? (_selectedItem == null ? 'Nueva Partida de Solicitud' : 'Editar Partida de Solicitud')
                        : 'Detalle de Solicitudes de Refacción',
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
                          label: const Text('Registrar Partida'),
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
    final listAsync = ref.watch(solicitudesRefaccionDetalleProvider);
    final solicitudesAsync = ref.watch(helperSolicitudesForDetalleProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForDetalleProvider);
    final equiposAsync = ref.watch(helperEquiposForDetalleProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de detalles.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final solicitudesMap = {
          for (var item in solicitudesAsync.value ?? [])
            item['id_solicitud_refaccion'] as int: item['folio'] as String
        };

        final refaccionesMap = {
          for (var item in refaccionesAsync.value ?? [])
            item['id_refaccion'] as int: '[${item['codigo_interno']}] ${item['descripcion_homologada']}'
        };

        final equiposMap = {
          for (var item in equiposAsync.value ?? [])
            item['id_equipo'] as int: '${item['codigo_activo_cliente'] ?? 'S/C'} (${item['marca'] ?? ''} ${item['modelo'] ?? ''})'
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FOLIO SOLICITUD', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('EQUIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('DESC. ORIGINAL', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. SOLICITADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. AUTORIZADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. SUMINISTRADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FECHA REQ.', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idSolicitudRefaccionDetalle.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(solicitudesMap[item.idSolicitudRefaccion] ?? 'Sol ID: ${item.idSolicitudRefaccion}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.idRefaccion != null ? (refaccionesMap[item.idRefaccion] ?? 'Ref ID: ${item.idRefaccion}') : '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.idEquipo != null ? (equiposMap[item.idEquipo] ?? 'Eq ID: ${item.idEquipo}') : '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.descripcionOriginal, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadSolicitada.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadAutorizada.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadSuministrada.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaRequerida != null ? item.fechaRequerida!.toLocal().toString().split(' ').first : '-', style: TextStyle(color: context.textColor))),
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
    final solicitudesAsync = ref.watch(helperSolicitudesForDetalleProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForDetalleProvider);
    final equiposAsync = ref.watch(helperEquiposForDetalleProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Solicitud & Refacción
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Solicitud de Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
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
                        Text('Refacción Homologada (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
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
                          items: [
                            const DropdownMenuItem<int?>(value: null, child: Text('Ninguna')),
                            ...(refaccionesAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              final code = item['codigo_interno'] as String;
                              final desc = item['descripcion_homologada'] as String;
                              return DropdownMenuItem<int?>(
                                value: item['id_refaccion'] as int,
                                child: Text('[$code] $desc', overflow: TextOverflow.ellipsis),
                              );
                            }),
                          ],
                          onChanged: (val) => setState(() => _selectedRefaccionId = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Equipo & Descripcion Original
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Equipo (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedEquipoId,
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
                            ...(equiposAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              final code = item['codigo_activo_cliente'] ?? 'S/C';
                              final brand = item['marca'] ?? '';
                              final model = item['modelo'] ?? '';
                              return DropdownMenuItem<int?>(
                                value: item['id_equipo'] as int,
                                child: Text('$code ($brand $model)', overflow: TextOverflow.ellipsis),
                              );
                            }),
                          ],
                          onChanged: (val) => setState(() => _selectedEquipoId = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Descripción Original / Solicitada *', _descOriginalCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Cantidad Necesaria & Cantidad Solicitada & Cantidad Autorizada
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Cantidad Necesaria *', _cantNecesariaCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad Solicitada *', _cantSolicitadaCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad Autorizada', _cantAutorizadaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Cantidad Pedida & Cantidad Suministrada & Cantidad Instalada
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Cantidad Pedida', _cantPedidaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad Suministrada', _cantSuministradaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad Instalada', _cantInstaladaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 5: Cantidad Cancelada & Fecha Requerida & Criticidad
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Cantidad Cancelada', _cantCanceladaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha Requerida', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fechaRequeridaCtrl,
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
                        Text('Criticidad', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String?>(
                          value: _selectedCriticidad,
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
                          onChanged: (val) => setState(() => _selectedCriticidad = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 6: Afectación Operativa & Estado & Activo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Afectación Operativa (%)', _afectacionCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado Partida *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
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
                            DropdownMenuItem<String>(value: 'AUTORIZADO', child: Text('AUTORIZADO')),
                            DropdownMenuItem<String>(value: 'PEDIDO', child: Text('PEDIDO')),
                            DropdownMenuItem<String>(value: 'SUMINISTRADO', child: Text('SUMINISTRADO')),
                            DropdownMenuItem<String>(value: 'INSTALADO', child: Text('INSTALADO')),
                            DropdownMenuItem<String>(value: 'CANCELADO', child: Text('CANCELADO')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedEstado = val);
                          },
                        ),
                      ],
                    ),
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
