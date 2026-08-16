import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/suministro_refaccion_detalle.dart';
import '../../providers/suministros_refaccion_detalle_provider.dart';

class CrudSuministrosRefaccionDetalleModal extends ConsumerStatefulWidget {
  const CrudSuministrosRefaccionDetalleModal({super.key});

  @override
  ConsumerState<CrudSuministrosRefaccionDetalleModal> createState() => _CrudSuministrosRefaccionDetalleModalState();
}

class _CrudSuministrosRefaccionDetalleModalState extends ConsumerState<CrudSuministrosRefaccionDetalleModal> {
  bool _isEditing = false;
  SuministroRefaccionDetalle? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedSuministroId;
  int? _selectedSolicitudDetalleId;
  late TextEditingController _cantidadEntregadaCtrl;
  late TextEditingController _cantidadRechazadaCtrl;
  late TextEditingController _motivoRechazoCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedSuministroId = _selectedItem?.idSuministro;
    _selectedSolicitudDetalleId = _selectedItem?.idSolicitudRefaccionDetalle;
    _cantidadEntregadaCtrl = TextEditingController(text: _selectedItem?.cantidadEntregada.toString() ?? '');
    _cantidadRechazadaCtrl = TextEditingController(text: _selectedItem?.cantidadRechazada.toString() ?? '0.0');
    _motivoRechazoCtrl = TextEditingController(text: _selectedItem?.motivoRechazo ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _cantidadEntregadaCtrl.dispose();
    _cantidadRechazadaCtrl.dispose();
    _motivoRechazoCtrl.dispose();
    super.dispose();
  }

  void _openForm([SuministroRefaccionDetalle? item]) {
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
    if (_selectedSuministroId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un Suministro')));
      return;
    }
    if (_selectedSolicitudDetalleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Partida Solicitada')));
      return;
    }

    final entregada = double.tryParse(_cantidadEntregadaCtrl.text) ?? 0.0;
    final rechazada = double.tryParse(_cantidadRechazadaCtrl.text) ?? 0.0;

    final item = SuministroRefaccionDetalle(
      idSuministroDetalle: _selectedItem?.idSuministroDetalle,
      idSuministro: _selectedSuministroId!,
      idSolicitudRefaccionDetalle: _selectedSolicitudDetalleId!,
      cantidadEntregada: entregada,
      cantidadRechazada: rechazada,
      motivoRechazo: _motivoRechazoCtrl.text.trim().isEmpty ? null : _motivoRechazoCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(suministrosRefaccionDetalleProvider.notifier).addDetalle(item);
      } else {
        await ref.read(suministrosRefaccionDetalleProvider.notifier).updateDetalle(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(SuministroRefaccionDetalle item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Partida Suministrada'),
        content: Text('¿Estás seguro de que deseas $action este registro de partida?'),
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

    if (confirm == true && item.idSuministroDetalle != null) {
      try {
        await ref.read(suministrosRefaccionDetalleProvider.notifier).toggleStatus(item.idSuministroDetalle!, item.activo);
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
                        ? (_selectedItem == null ? 'Nueva Partida Suministrada' : 'Editar Partida Suministrada')
                        : 'Partidas Suministradas (Detalle)',
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
    final listAsync = ref.watch(suministrosRefaccionDetalleProvider);
    final suministrosAsync = ref.watch(helperSuministrosForDetalleProvider);
    final solicitudDetallesAsync = ref.watch(helperSolicitudDetallesForSuministroProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de partidas suministradas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final suministrosMap = {
          for (var item in suministrosAsync.value ?? [])
            item['id_suministro'] as int: 'ID: ${item['id_suministro']} [Doc: ${item['documento_referencia'] ?? 'S/D'}] (${item['fuente_suministro']})'
        };

        final solicitudDetallesMap = {
          for (var item in solicitudDetallesAsync.value ?? [])
            item['id_solicitud_refaccion_detalle'] as int: () {
              final refObj = item['refaccion'] as Map<String, dynamic>?;
              final code = refObj?['codigo_interno'] ?? 'S/C';
              final desc = refObj?['descripcion_homologada'] ?? 'S/D';
              return '[$code] $desc (Sol: ${item['cantidad_solicitada']})';
            }()
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('SUMINISTRO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN SOLICITADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. ENTREGADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANT. RECHAZADA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MOTIVO RECHAZO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idSuministroDetalle.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(suministrosMap[item.idSuministro] ?? 'Suministro ID: ${item.idSuministro}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(solicitudDetallesMap[item.idSolicitudRefaccionDetalle] ?? 'Detalle ID: ${item.idSolicitudRefaccionDetalle}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadEntregada.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.cantidadRechazada.toStringAsFixed(2), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.motivoRechazo ?? '-', style: TextStyle(color: context.textColor))),
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
    final suministrosAsync = ref.watch(helperSuministrosForDetalleProvider);
    final solicitudDetallesAsync = ref.watch(helperSolicitudDetallesForSuministroProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Suministro & Solicitud Detalle
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Suministro de Origen *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedSuministroId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (suministrosAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final doc = item['documento_referencia'] ?? 'Sin Doc';
                            final src = item['fuente_suministro'] ?? 'Sin Fuente';
                            return DropdownMenuItem<int>(
                              value: item['id_suministro'] as int,
                              child: Text('ID: ${item['id_suministro']} [$doc] ($src)', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedSuministroId = val),
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
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Cantidad Entregada & Cantidad Rechazada
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Cantidad Entregada *', _cantidadEntregadaCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad Rechazada', _cantidadRechazadaCtrl, required: false, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Motivo Rechazo & Activo
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Motivo Rechazo', _motivoRechazoCtrl),
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
