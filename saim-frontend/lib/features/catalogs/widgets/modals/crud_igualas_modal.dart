import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/iguala.dart';
import '../../providers/igualas_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudIgualasModal extends ConsumerStatefulWidget {
  const CrudIgualasModal({super.key});

  @override
  ConsumerState<CrudIgualasModal> createState() => _CrudIgualasModalState();
}

class _CrudIgualasModalState extends ConsumerState<CrudIgualasModal> {
  bool _isEditing = false;
  Iguala? _selectedIguala;

  final _formKey = GlobalKey<FormState>();
  
  int? _selectedTiendaId;
  int? _selectedTipoServicioId;
  late TextEditingController _codigoIgualaCtrl;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  String _selectedEstatus = 'ACTIVA';
  late TextEditingController _motivoBajaCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedTiendaId = _selectedIguala?.idTienda;
    _selectedTipoServicioId = _selectedIguala?.idTipoServicio;
    _codigoIgualaCtrl = TextEditingController(text: _selectedIguala?.codigoIguala ?? '');
    
    _fechaInicioCtrl = TextEditingController(
      text: _selectedIguala != null
          ? _selectedIguala!.fechaInicio.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first
    );
    
    _fechaFinCtrl = TextEditingController(
      text: _selectedIguala != null
          ? _selectedIguala!.fechaFin.toIso8601String().split('T').first
          : DateTime.now().add(const Duration(days: 365)).toIso8601String().split('T').first
    );
    
    _selectedEstatus = _selectedIguala?.estatus ?? 'BORRADOR';
    _motivoBajaCtrl = TextEditingController(text: _selectedIguala?.motivoBaja ?? '');
    _activo = _selectedIguala?.activo ?? true;
  }

  void _actualizarCodigoIguala() {
    if (_selectedTiendaId == null || _selectedTipoServicioId == null || _fechaInicioCtrl.text.isEmpty) {
      _codigoIgualaCtrl.text = '';
      return;
    }

    final tiendasAsync = ref.read(helperTiendasForIgualaProvider);
    final tiposServicioAsync = ref.read(helperTiposServicioForIgualaProvider);

    final tiendas = tiendasAsync.value ?? [];
    final tipos = tiposServicioAsync.value ?? [];

    if (tiendas.isEmpty || tipos.isEmpty) return;

    final tienda = tiendas.firstWhere((t) => t['id_tienda'] == _selectedTiendaId, orElse: () => <String, dynamic>{});
    final tipoServicio = tipos.firstWhere((ts) => ts['id_tipo_servicio'] == _selectedTipoServicioId, orElse: () => <String, dynamic>{});

    if (tienda.isEmpty || tipoServicio.isEmpty) return;

    final nombreTienda = (tienda['nombre'] as String).toUpperCase().replaceAll(' ', '_');
    final determinante = tienda['determinante'] as String? ?? '000';
    final codigoRef = tipoServicio['codigo'] as String? ?? 'XXX';
    final anio = _fechaInicioCtrl.text.split('-').first;
    final idStr = (_selectedIguala != null && _selectedIguala!.idIguala != 0) 
        ? _selectedIguala!.idIguala.toString().padLeft(4, '0') 
        : '[AUTO]';

    _codigoIgualaCtrl.text = 'IG-$nombreTienda-$idStr-$determinante-$codigoRef-$anio';
  }

  @override
  void dispose() {
    _codigoIgualaCtrl.dispose();
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _motivoBajaCtrl.dispose();
    super.dispose();
  }

  void _openForm([Iguala? iguala]) {
    setState(() {
      _selectedIguala = iguala;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedIguala = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTiendaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una Tienda'))
      );
      return;
    }
    if (_selectedTipoServicioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un Tipo de Servicio'))
      );
      return;
    }

    final iguala = Iguala(
      idIguala: _selectedIguala?.idIguala ?? 0,
      idTienda: _selectedTiendaId!,
      idTipoServicio: _selectedTipoServicioId!,
      codigoIguala: _codigoIgualaCtrl.text.trim(),
      fechaInicio: DateTime.parse(_fechaInicioCtrl.text),
      fechaFin: DateTime.parse(_fechaFinCtrl.text),
      estatus: _selectedEstatus,
      motivoBaja: _selectedEstatus == 'CANCELADA' && _motivoBajaCtrl.text.trim().isNotEmpty
          ? _motivoBajaCtrl.text.trim()
          : null,
      activo: _activo,
    );

    try {
      if (_selectedIguala == null) {
        await ref.read(igualasProvider.notifier).addIguala(iguala);
      } else {
        await ref.read(igualasProvider.notifier).updateIguala(iguala);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(Iguala iguala) async {
    final action = iguala.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${iguala.activo ? 'Desactivar' : 'Activar'} Iguala'),
        content: Text('¿Estás seguro de que deseas $action esta iguala?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(iguala.activo ? 'Desactivar' : 'Activar'),
          ),
        ],
      ),
    );

    if (confirm == true && iguala.idIguala != null) {
      try {
        await ref.read(igualasProvider.notifier).toggleStatus(iguala.idIguala!, iguala.activo);
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
                        ? (_selectedIguala == null ? 'Nueva Iguala' : 'Editar Iguala')
                        : 'Gestión de Igualas',
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
                          label: const Text('Agregar Iguala'),
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
    final listAsync = ref.watch(igualasProvider);
    final tiendasAsync = ref.watch(helperTiendasForIgualaProvider);
    final tiposServicioAsync = ref.watch(helperTiposServicioForIgualaProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de igualas.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final tiendasMap = {
          for (var item in tiendasAsync.value ?? [])
            item['id_tienda'] as int: item['nombre'] as String
        };

        final tiposServicioMap = {
          for (var item in tiposServicioAsync.value ?? [])
            item['id_tipo_servicio'] as int: item['nombre'] as String
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CÓDIGO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('TIPO SERVICIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('TIENDA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('INICIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FIN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idIguala.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.codigoIguala, style: TextStyle(color: context.textColor))),
                  DataCell(Text(tiposServicioMap[item.idTipoServicio] ?? 'ID: ${item.idTipoServicio}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(tiendasMap[item.idTienda] ?? 'ID: ${item.idTienda}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaInicio.toIso8601String().split('T').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaFin.toIso8601String().split('T').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.estatus, style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.activo ? 'Activa' : 'Inactiva',
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
    final tiendasAsync = ref.watch(helperTiendasForIgualaProvider);
    final tiposServicioAsync = ref.watch(helperTiposServicioForIgualaProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Zona Tienda & Código Iguala
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tienda *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedTiendaId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (tiendasAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final id = item['id_tienda'] as int;
                            final nombre = item['nombre'] as String;
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(nombre),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedTiendaId = val;
                              _actualizarCodigoIguala();
                            });
                          },
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
                        Text('Tipo de Servicio *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedTipoServicioId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (tiposServicioAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_tipo_servicio'] as int,
                              child: Text(item['nombre'] as String),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedTipoServicioId = val;
                              _actualizarCodigoIguala();
                            });
                          },
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Row 2: Fechas
              Row(
                children: [
                  Expanded(
                    child: _buildDateField('Fecha Inicio *', _fechaInicioCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField('Fecha Fin *', _fechaFinCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Estatus & Código Iguala
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estatus *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedEstatus,
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
                            DropdownMenuItem<String>(value: 'BORRADOR', child: Text('BORRADOR')),
                            DropdownMenuItem<String>(value: 'VIGENTE', child: Text('VIGENTE')),
                            DropdownMenuItem<String>(value: 'SUSPENDIDA', child: Text('SUSPENDIDA')),
                            DropdownMenuItem<String>(value: 'TERMINADA', child: Text('TERMINADA')),
                            DropdownMenuItem<String>(value: 'CANCELADA', child: Text('CANCELADA')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedEstatus = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Código Iguala *', _codigoIgualaCtrl, required: true, readOnly: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Multiline text: Motivo Baja (solo visible si estatus es CANCELADA)
              if (_selectedEstatus == 'CANCELADA') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Motivo de Baja *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _motivoBajaCtrl,
                      maxLines: 3,
                      maxLength: 500,
                      style: TextStyle(color: context.textColor),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: context.backgroundColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Requerido cuando el estatus es CANCELADA' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

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
                    onPressed: _codigoIgualaCtrl.text.isEmpty ? null : _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _codigoIgualaCtrl.text.isEmpty ? context.mutedTextColor : AppColors.blue,
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
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

  Widget _buildDateField(String label, TextEditingController controller, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          readOnly: true,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            suffixIcon: Icon(Icons.calendar_today, size: 18, color: context.mutedTextColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
          ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.text.isNotEmpty ? DateTime.tryParse(controller.text) ?? DateTime.now() : DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                controller.text = picked.toIso8601String().split('T').first;
                if (label.contains('Inicio')) {
                  _actualizarCodigoIguala();
                }
              });
            }
          },
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
