import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/iguala_condicion.dart';
import '../../providers/iguala_condiciones_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudIgualaCondicionesModal extends ConsumerStatefulWidget {
  const CrudIgualaCondicionesModal({super.key});

  @override
  ConsumerState<CrudIgualaCondicionesModal> createState() => _CrudIgualaCondicionesModalState();
}

class _CrudIgualaCondicionesModalState extends ConsumerState<CrudIgualaCondicionesModal> {
  bool _isEditing = false;
  IgualaCondicion? _selectedItem;

  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  int? _selectedIgualaId;
  int? _selectedIgualaServicioId;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  String? _selectedPeriodicidadPreventivo;
  String? _selectedPeriodicidadFacturacion;
  late TextEditingController _montoPeriodicoCtrl;
  late TextEditingController _monedaCtrl;
  late TextEditingController _duracionEstandarCtrl;
  late TextEditingController _numeroJornadasCtrl;
  late TextEditingController _horasPorJornadaCtrl;
  late TextEditingController _tecnicosMinimosCtrl;
  late TextEditingController _tecnicosObjetivoCtrl;
  late TextEditingController _toleranciaDesviacionCtrl;
  bool _incluyeDiagnostico = false;
  late TextEditingController _limiteCorrectivoCtrl;
  late TextEditingController _alcanceParticularCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedIgualaId = _selectedItem?.idIguala;
    _selectedIgualaServicioId = _selectedItem?.idIgualaServicio;
    
    _fechaInicioCtrl = TextEditingController(
      text: _selectedItem != null
          ? _selectedItem!.fechaInicioVigencia.toIso8601String().split('T').first
          : DateTime.now().toIso8601String().split('T').first
    );
    _fechaFinCtrl = TextEditingController(
      text: _selectedItem?.fechaFinVigencia?.toIso8601String().split('T').first ?? ''
    );
    _selectedPeriodicidadPreventivo = _selectedItem?.periodicidadPreventivo ?? 'MENSUAL';
    _selectedPeriodicidadFacturacion = _selectedItem?.periodicidadFacturacion ?? 'MENSUAL';
    _montoPeriodicoCtrl = TextEditingController(text: _selectedItem?.montoPeriodico.toString() ?? '0.00');
    _monedaCtrl = TextEditingController(text: _selectedItem?.moneda ?? 'MXN');
    _duracionEstandarCtrl = TextEditingController(text: _selectedItem?.duracionEstandarMinutos.toString() ?? '60');
    _numeroJornadasCtrl = TextEditingController(text: _selectedItem?.numeroJornadas.toString() ?? '1');
    _horasPorJornadaCtrl = TextEditingController(text: _selectedItem?.horasPorJornada.toString() ?? '8.0');
    _tecnicosMinimosCtrl = TextEditingController(text: _selectedItem?.tecnicosMinimos.toString() ?? '1');
    _tecnicosObjetivoCtrl = TextEditingController(text: _selectedItem?.tecnicosObjetivo.toString() ?? '2');
    _toleranciaDesviacionCtrl = TextEditingController(text: _selectedItem?.toleranciaDesviacionPct.toString() ?? '10.0');
    _incluyeDiagnostico = _selectedItem?.incluyeDiagnosticoCorrectivo ?? false;
    _limiteCorrectivoCtrl = TextEditingController(text: _selectedItem?.limiteCorrectivoIncluido?.toString() ?? '');
    _alcanceParticularCtrl = TextEditingController(text: _selectedItem?.alcanceParticular ?? '');
    _activo = _selectedItem?.activo ?? true;
  }

  @override
  void dispose() {
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _montoPeriodicoCtrl.dispose();
    _monedaCtrl.dispose();
    _duracionEstandarCtrl.dispose();
    _numeroJornadasCtrl.dispose();
    _horasPorJornadaCtrl.dispose();
    _tecnicosMinimosCtrl.dispose();
    _tecnicosObjetivoCtrl.dispose();
    _toleranciaDesviacionCtrl.dispose();
    _limiteCorrectivoCtrl.dispose();
    _alcanceParticularCtrl.dispose();
    super.dispose();
  }

  void _openForm([IgualaCondicion? item]) {
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

    final item = IgualaCondicion(
      idIgualaCondicion: _selectedItem?.idIgualaCondicion,
      idIguala: _selectedIgualaId!,
      idIgualaServicio: _selectedIgualaServicioId,
      fechaInicioVigencia: DateTime.parse(_fechaInicioCtrl.text),
      fechaFinVigencia: _fechaFinCtrl.text.isNotEmpty ? DateTime.parse(_fechaFinCtrl.text) : null,
      periodicidadPreventivo: _selectedPeriodicidadPreventivo ?? 'MENSUAL',
      periodicidadFacturacion: _selectedPeriodicidadFacturacion ?? 'MENSUAL',
      montoPeriodico: double.tryParse(_montoPeriodicoCtrl.text) ?? 0.0,
      moneda: _monedaCtrl.text.trim(),
      duracionEstandarMinutos: int.tryParse(_duracionEstandarCtrl.text) ?? 60,
      numeroJornadas: int.tryParse(_numeroJornadasCtrl.text) ?? 1,
      horasPorJornada: double.tryParse(_horasPorJornadaCtrl.text) ?? 8.0,
      tecnicosMinimos: int.tryParse(_tecnicosMinimosCtrl.text) ?? 1,
      tecnicosObjetivo: int.tryParse(_tecnicosObjetivoCtrl.text) ?? 2,
      toleranciaDesviacionPct: double.tryParse(_toleranciaDesviacionCtrl.text) ?? 10.0,
      incluyeDiagnosticoCorrectivo: _incluyeDiagnostico,
      limiteCorrectivoIncluido: double.tryParse(_limiteCorrectivoCtrl.text),
      alcanceParticular: _alcanceParticularCtrl.text.trim().isEmpty ? null : _alcanceParticularCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedItem == null) {
        await ref.read(igualaCondicionesProvider.notifier).addIgualaCondicion(item);
      } else {
        await ref.read(igualaCondicionesProvider.notifier).updateIgualaCondicion(item);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(IgualaCondicion item) async {
    final action = item.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${item.activo ? 'Desactivar' : 'Activar'} Condición de Iguala'),
        content: Text('¿Estás seguro de que deseas $action esta condición de iguala?'),
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

    if (confirm == true && item.idIgualaCondicion != null) {
      try {
        await ref.read(igualaCondicionesProvider.notifier).toggleStatus(item.idIgualaCondicion!, item.activo);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
        height: 700,
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
                        ? (_selectedItem == null ? 'Nueva Condición de Iguala' : 'Editar Condición de Iguala')
                        : 'Gestión de Condiciones de Iguala',
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
                          label: const Text('Agregar Condición'),
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
    final listAsync = ref.watch(igualaCondicionesProvider);
    final igualasAsync = ref.watch(helperIgualasProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de condiciones de iguala.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final igualasMap = {
          for (var item in igualasAsync.value ?? [])
            (item['id_iguala'] as num).toInt(): item['codigo_iguala'] as String
        };

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('IGUALA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MONTO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('MONEDA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('INICIO VIGENCIA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.idIgualaCondicion.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(igualasMap[item.idIguala] ?? 'ID: ${item.idIguala}', style: TextStyle(color: context.textColor))),
                  DataCell(Text('\$${item.montoPeriodico.toStringAsFixed(2)}', style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.moneda, style: TextStyle(color: context.textColor))),
                  DataCell(Text(item.fechaInicioVigencia.toIso8601String().split('T').first, style: TextStyle(color: context.textColor))),
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
    final igualasAsync = ref.watch(helperIgualasProvider);
    final serviciosAsync = ref.watch(helperIgualaServiciosProvider);

    // Esperar a que todos los helpers carguen antes de renderizar el form.
    // Si el form se renderiza antes de que los items del dropdown carguen,
    // Flutter lanza assertion error cuando el value actual no está en la lista.
    if (igualasAsync.isLoading || serviciosAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (igualasAsync.hasError || serviciosAsync.hasError) {
      return Center(
        child: Text(
          'Error al cargar datos: ${igualasAsync.error ?? serviciosAsync.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grid Row 1: Iguala & Servicio
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
                              value: (item['id_iguala'] as num).toInt(),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Iguala Servicio (Opcional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int?>(
                          value: _selectedIgualaServicioId,
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
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Ninguno'),
                            ),
                            ...(serviciosAsync.value ?? []).map<DropdownMenuItem<int?>>((item) {
                              return DropdownMenuItem<int?>(
                                value: (item['id_iguala_servicio'] as num).toInt(),
                                child: Text(item['alcance_particular'] ?? 'Sin alcance especificado'),
                              );
                            })
                          ],
                          onChanged: (val) => setState(() => _selectedIgualaServicioId = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grid Row 2: Fechas
              Row(
                children: [
                  Expanded(
                    child: _buildDateField('Inicio Vigencia *', _fechaInicioCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField('Fin Vigencia', _fechaFinCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grid Row 3: Periodicidad preventivo y facturacion
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Periodicidad Preventivo *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedPeriodicidadPreventivo,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (ref.watch(helperPeriodicidadesProvider).value ?? []).map<DropdownMenuItem<String>>((item) {
                            final nombre = item['nombre'] as String;
                            return DropdownMenuItem<String>(
                              value: nombre,
                              child: Text(nombre),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedPeriodicidadPreventivo = val),
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
                        Text('Periodicidad Facturación *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedPeriodicidadFacturacion,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (ref.watch(helperPeriodicidadesProvider).value ?? []).map<DropdownMenuItem<String>>((item) {
                            final nombre = item['nombre'] as String;
                            return DropdownMenuItem<String>(
                              value: nombre,
                              child: Text(nombre),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedPeriodicidadFacturacion = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grid Row 4: Monto y Moneda
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Monto Periódico *', _montoPeriodicoCtrl, required: true, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Moneda *', _monedaCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grid Row 5: Duracion estandar, numero jornadas, horas por jornada
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Duración Estándar (Minutos) *', _duracionEstandarCtrl, required: true, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Número de Jornadas *', _numeroJornadasCtrl, required: true, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Horas por Jornada *', _horasPorJornadaCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grid Row 6: Tecnicos minimos, tecnicos objetivo, tolerancia desviacion
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Técnicos Mínimos *', _tecnicosMinimosCtrl, required: true, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Técnicos Objetivo *', _tecnicosObjetivoCtrl, required: true, keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Tolerancia Desviación (%) *', _toleranciaDesviacionCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grid Row 7: Incluye diagnostico, limite correctivo
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('Incluye Diagnóstico Correctivo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Switch(
                          value: _incluyeDiagnostico,
                          onChanged: (val) {
                            setState(() {
                              _incluyeDiagnostico = val;
                            });
                          },
                          activeColor: AppColors.green,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Límite Correctivo Incluido', _limiteCorrectivoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Multiline text: Alcance particular
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

              // Save & cancel buttons
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
