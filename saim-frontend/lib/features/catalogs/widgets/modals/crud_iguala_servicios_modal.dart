import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/iguala_servicio.dart';
import '../../providers/iguala_servicios_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudIgualaServiciosModal extends ConsumerStatefulWidget {
  const CrudIgualaServiciosModal({super.key});

  @override
  ConsumerState<CrudIgualaServiciosModal> createState() => _CrudIgualaServiciosModalState();
}

class _CrudIgualaServiciosModalState extends ConsumerState<CrudIgualaServiciosModal> {
  bool _isEditing = false;
  IgualaServicio? _selectedItem;

  final _formKey = GlobalKey<FormState>();

  int? _selectedIgualaId;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  bool _esPrincipal = false;
  late TextEditingController _alcanceParticularCtrl;
  String _selectedEstatus = 'VIGENTE';
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedIgualaId = _selectedItem?.idIguala;
    
    _fechaInicioCtrl = TextEditingController(
      text: _selectedItem != null
          ? _selectedItem!.fechaInicio.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first
    );
    
    _fechaFinCtrl = TextEditingController(
      text: _selectedItem?.fechaFin?.toIso8601String().split('T').first ?? ''
    );
    
    _esPrincipal = _selectedItem?.esPrincipal ?? false;
    _alcanceParticularCtrl = TextEditingController(text: _selectedItem?.alcanceParticular ?? '');
    _selectedEstatus = _selectedItem?.estatus ?? 'VIGENTE';
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _alcanceParticularCtrl.dispose();
    super.dispose();
  }

  void _openForm([IgualaServicio? item]) {
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
    if (_selectedIgualaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Iguala')));
      return;
    }

    final item = IgualaServicio(
      idIgualaServicio: _selectedItem?.idIgualaServicio,
      idIguala: _selectedIgualaId!,
      fechaInicio: DateTime.parse(_fechaInicioCtrl.text),
      fechaFin: _fechaFinCtrl.text.isNotEmpty ? DateTime.parse(_fechaFinCtrl.text) : null,
      esPrincipal: _esPrincipal,
      alcanceParticular: _alcanceParticularCtrl.text.trim().isEmpty ? null : _alcanceParticularCtrl.text.trim(),
      estatus: _selectedEstatus,
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(igualaServiciosProvider.notifier).addIgualaServicio(item);
      } else {
        await ref.read(igualaServiciosProvider.notifier).updateIgualaServicio(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _toggleStatus(IgualaServicio item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Servicio de Iguala'),
        content: Text('¿Estás seguro de que deseas $action este servicio de iguala?'),
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

    if (confirm == true && item.idIgualaServicio != null) {
      try {
        await ref.read(igualaServiciosProvider.notifier).toggleStatus(item.idIgualaServicio!, item.activo);
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
                        ? (_selectedItem == null ? 'Nuevo Servicio de Iguala' : 'Editar Servicio de Iguala')
                        : 'Gestión de Servicios de Iguala',
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
                          label: const Text('Agregar Servicio'),
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
    final listAsync = ref.watch(igualaServiciosProvider);
    final igualasAsync = ref.watch(helperIgualasForServicioProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de servicios de iguala.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final igualasMap = {
          for (var item in igualasAsync.value ?? [])
            item['id_iguala'] as int: item['codigo_iguala'] as String
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('IGUALA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('PRINCIPAL', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('INICIO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FIN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idIgualaServicio.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(igualasMap[item.idIguala] ?? 'ID: ${item.idIguala}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.esPrincipal ? 'Sí' : 'No', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaInicio.toIso8601String().split('T').first, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaFin?.toIso8601String().split('T').first ?? '-', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.estatus, style: TextStyle(color: context.textColor))),
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
    final igualasAsync = ref.watch(helperIgualasForServicioProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Iguala & Tipo Servicio
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Iguala *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedIgualaId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (igualasAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_iguala'] as int,
                              child: Text(item['codigo_iguala'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedIgualaId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Fechas
              Row(
                children: [
                  Expanded(
                    child: _buildDateField('Fecha Inicio *', _fechaInicioCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField('Fecha Fin (Opcional)', _fechaFinCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Estatus & Es Principal
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
                            DropdownMenuItem<String>(value: 'VIGENTE', child: Text('VIGENTE')),
                            DropdownMenuItem<String>(value: 'SUSPENDIDO', child: Text('SUSPENDIDO')),
                            DropdownMenuItem<String>(value: 'TERMINADO', child: Text('TERMINADO')),
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
                    child: Row(
                      children: [
                        Text('Es Principal', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _esPrincipal,
                          onChanged: (val) {
                            setState(() {
                              _esPrincipal = val;
                            });
                          },
                          activeColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Multiline text: Alcance Particular
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alcance Particular', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _alcanceParticularCtrl,
                    maxLines: 3,
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
              controller.text = picked.toIso8601String().split('T').first;
            }
          },
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
