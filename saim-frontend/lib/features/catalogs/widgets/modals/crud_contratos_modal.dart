import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/clientes_provider.dart';
import '../../providers/contratos_provider.dart';
import '../../models/contrato.dart';
import '../../providers/zonas_contrato_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/modal_data_table.dart';
// ─────────────────────────────────────────────────────────────────────────────
// State model — holds all wizard data in memory until final submit
// ─────────────────────────────────────────────────────────────────────────────

class _ZonaData {
  int? idZonaContrato;
  String codigo;
  String nombre;
  String descripcion;
  List<_AlcanceData> alcances;
  List<_SlaData> slas;

  _ZonaData({
    this.idZonaContrato,
    this.codigo = '',
    this.nombre = '',
    this.descripcion = '',
    List<_AlcanceData>? alcances,
    List<_SlaData>? slas,
  })  : alcances = alcances ?? [],
        slas = slas ?? [];

  Map<String, dynamic> toJson() => {
        if (idZonaContrato != null) 'id_zona_contrato': idZonaContrato,
        'codigo': codigo,
        'nombre': nombre,
        'descripcion': descripcion,
        'alcances': alcances.map((a) => a.toJson()).toList(),
        'slas': slas.map((s) => s.toJson()).toList(),
      };
}

class _AlcanceData {
  int? idAlcance;
  String idTipoServicio;
  String descripcion;

  _AlcanceData({
    this.idAlcance,
    this.idTipoServicio = '',
    this.descripcion = '',
  });

  Map<String, dynamic> toJson() => {
        if (idAlcance != null) 'id_alcance': idAlcance,
        'id_tipo_servicio': idTipoServicio.isEmpty ? null : int.tryParse(idTipoServicio),
        'descripcion': descripcion,
      };
}

class _SlaData {
  int? idSla;
  String prioridad;
  String horarioCobertura;
  String minutosRespuesta;
  String minutosLlegada;
  String minutosSolucion;
  String reglaEscalamiento;

  _SlaData({
    this.idSla,
    this.prioridad = 'Media',
    this.horarioCobertura = '8x5',
    this.minutosRespuesta = '',
    this.minutosLlegada = '',
    this.minutosSolucion = '',
    this.reglaEscalamiento = '',
  });

  Map<String, dynamic> toJson() => {
        if (idSla != null) 'id_sla': idSla,
        'prioridad': prioridad,
        'horario_cobertura': horarioCobertura,
        'minutos_respuesta': int.tryParse(minutosRespuesta) ?? 0,
        'minutos_llegada': minutosLlegada.isEmpty ? null : int.tryParse(minutosLlegada),
        'minutos_solucion_objetivo': minutosSolucion.isEmpty ? null : int.tryParse(minutosSolucion),
        'regla_escalamiento': reglaEscalamiento,
      };
}

class _DocumentoData {
  int? idDocumento;
  String tipoDocumento;
  String nombreArchivo;
  String rutaArchivo;
  String hashSha256;
  String fechaDocumento;
  bool esVigente;
  _DocumentoData({
    this.idDocumento,
    this.tipoDocumento = 'Contrato Principal',
    this.nombreArchivo = '',
    this.rutaArchivo = '',
    this.hashSha256 = '',
    this.fechaDocumento = '',
    this.esVigente = true,
  });
  Map<String, dynamic> toJson() => {
        if (idDocumento != null) 'id_documento': idDocumento,
        'tipo_documento': tipoDocumento,
        'nombre_archivo': nombreArchivo,
        'ruta_archivo': rutaArchivo,
        'hash_sha256': hashSha256,
        'fecha_documento': fechaDocumento.isEmpty ? null : fechaDocumento,
        'es_vigente': esVigente,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Widget
// ─────────────────────────────────────────────────────────────────────────────

class CrudContratosModal extends ConsumerStatefulWidget {
  const CrudContratosModal({super.key});

  @override
  ConsumerState<CrudContratosModal> createState() => _CrudContratosModalState();
}

class _CrudContratosModalState extends ConsumerState<CrudContratosModal> {
  // --- Wizard state ---
  bool _isCreating = false; // false = list view, true = stepper
  int _currentStep = 0;
  bool _isSaving = false;

  // Form keys per step
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  // ── Step 1: Contrato ──
  int? _idContrato;
  int? _idCliente;
  final _numeroContratoCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _fechaFirmaCtrl = TextEditingController();
  final _fechaInicioCtrl = TextEditingController();
  final _fechaFinCtrl = TextEditingController();
  final _montoGlobalCtrl = TextEditingController();
  String _moneda = 'MXN';
  String _periodicidad = 'Mensual';
  String _estatus = 'Vigente';

  // ── Step 2: Versión ──
  int? _idContratoVersion;
  final _versionNumCtrl = TextEditingController(text: '1');
  final _versionFechaInicioCtrl = TextEditingController();
  final _versionFechaFinCtrl = TextEditingController();
  final _versionDescCtrl = TextEditingController(text: 'Versión inicial');

  // ── Step 3: Zonas ──
  final List<_ZonaData> _zonas = [];

  // ── Step 5: Documentos ──
  final List<_DocumentoData> _documentos = [];

  @override
  void dispose() {
    _numeroContratoCtrl.dispose();
    _nombreCtrl.dispose();
    _fechaFirmaCtrl.dispose();
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _montoGlobalCtrl.dispose();
    _versionNumCtrl.dispose();
    _versionFechaInicioCtrl.dispose();
    _versionFechaFinCtrl.dispose();
    _versionDescCtrl.dispose();
    super.dispose();
  }

  void _resetWizard() {
    setState(() {
      _isCreating = false;
      _currentStep = 0;
      _isSaving = false;
      _idContrato = null;
      _idCliente = null;
      _idContratoVersion = null;
      _numeroContratoCtrl.clear();
      _nombreCtrl.clear();
      _fechaFirmaCtrl.clear();
      _fechaInicioCtrl.clear();
      _fechaFinCtrl.clear();
      _montoGlobalCtrl.clear();
      _moneda = 'MXN';
      _periodicidad = 'Mensual';
      _estatus = 'Vigente';
      _versionNumCtrl.text = '1';
      _versionFechaInicioCtrl.clear();
      _versionFechaFinCtrl.clear();
      _versionDescCtrl.text = 'Versión inicial';
      _zonas.clear();
      _documentos.clear();
    });
  }

  Future<void> _deleteContratoDialog(Contrato contrato) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Contrato'),
        content: const Text('¿Estás seguro de eliminar este contrato? Se marcará como inactivo.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && contrato.idContrato != null) {
      try {
        await ref.read(contratosProvider.notifier).deleteContrato(contrato.idContrato!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
        }
      }
    }
  }

  Future<void> _openEditWizard(Contrato contrato) async {
    setState(() {
      _isCreating = true;
      _currentStep = 0;
      _isSaving = true;
    });

    final supabase = ref.read(supabaseClientProvider);
    try {
      final data = await supabase
          .from('contrato')
          .select('*, contrato_version(*, zona_contrato(*, contrato_alcance(*), contrato_sla(*)), contrato_documento(*))')
          .eq('id_contrato', contrato.idContrato!)
          .single();

      if (mounted) {
        setState(() {
          _idContrato = data['id_contrato'];
          _idCliente = data['id_cliente'];
          _numeroContratoCtrl.text = data['numero_contrato'] ?? '';
          _nombreCtrl.text = data['nombre'] ?? '';
          _fechaFirmaCtrl.text = data['fecha_firma'] ?? '';
          _fechaInicioCtrl.text = data['fecha_inicio'] ?? '';
          _fechaFinCtrl.text = data['fecha_fin'] ?? '';
          _montoGlobalCtrl.text = data['monto_global']?.toString() ?? '';
          _moneda = data['moneda'] ?? 'MXN';
          _periodicidad = data['periodicidad_facturacion'] ?? 'Mensual';
          _estatus = data['estatus'] ?? 'Vigente';

          final versions = List<Map<String, dynamic>>.from(data['contrato_version'] ?? []);
          final currentVersion = versions.where((v) => v['activo'] == true).firstOrNull ?? (versions.isNotEmpty ? versions.first : null);

          if (currentVersion != null) {
            _idContratoVersion = currentVersion['id_contrato_version'];
            final currentVersionNum = currentVersion['numero_version'] ?? 0;
            _versionNumCtrl.text = (currentVersionNum + 1).toString();
            _versionFechaInicioCtrl.text = currentVersion['fecha_inicio_vigencia'] ?? '';
            _versionFechaFinCtrl.text = currentVersion['fecha_fin_vigencia'] ?? '';
            _versionDescCtrl.text = currentVersion['motivo_version'] ?? '';

            final zonasData = List<Map<String, dynamic>>.from(currentVersion['zona_contrato'] ?? []).where((z) => z['activo'] == true).toList();
            _zonas.clear();
            for (var z in zonasData) {
              final alcancesData = List<Map<String, dynamic>>.from(z['contrato_alcance'] ?? []).where((a) => a['activo'] == true).toList();
              final slasData = List<Map<String, dynamic>>.from(z['contrato_sla'] ?? []).where((s) => s['activo'] == true).toList();

              _zonas.add(_ZonaData(
                idZonaContrato: z['id_zona_contrato'],
                codigo: z['codigo'] ?? '',
                nombre: z['nombre'] ?? '',
                descripcion: z['descripcion'] ?? '',
                alcances: alcancesData.map((a) => _AlcanceData(
                  idAlcance: a['id_contrato_alcance'],
                  idTipoServicio: a['id_tipo_servicio']?.toString() ?? '',
                  descripcion: a['descripcion'] ?? '',
                )).toList(),
                slas: slasData.map((s) => _SlaData(
                  idSla: s['id_contrato_sla'],
                  prioridad: s['prioridad'] ?? 'Media',
                  horarioCobertura: s['horario_cobertura'] ?? '8x5',
                  minutosRespuesta: s['minutos_respuesta']?.toString() ?? '',
                  minutosLlegada: s['minutos_llegada']?.toString() ?? '',
                  minutosSolucion: s['minutos_solucion_objetivo']?.toString() ?? '',
                  reglaEscalamiento: s['regla_escalamiento'] ?? '',
                )).toList(),
              ));
            }

            final docsData = List<Map<String, dynamic>>.from(currentVersion['contrato_documento'] ?? []).where((d) => d['activo'] == true).toList();
            _documentos.clear();
            for (var d in docsData) {
              _documentos.add(_DocumentoData(
                idDocumento: d['id_contrato_documento'],
                tipoDocumento: d['tipo_documento'] ?? 'Contrato Principal',
                nombreArchivo: d['nombre_archivo'] ?? '',
                rutaArchivo: d['ruta_archivo'] ?? '',
                hashSha256: d['hash_sha256'] ?? '',
                fechaDocumento: d['fecha_documento'] ?? '',
                esVigente: d['es_vigente'] ?? true,
              ));
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar contrato: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ctrl.text.isNotEmpty
          ? DateTime.tryParse(ctrl.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2150),
    );
    if (picked != null && mounted) {
      setState(() {
        ctrl.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<int> _getCurrentUserId() async {
    final supabase = ref.read(supabaseClientProvider);
    try {
      final authUser = supabase.auth.currentUser;
      if (authUser != null) {
        final res = await supabase
            .from('usuario')
            .select('id_usuario')
            .eq('correo', authUser.email as Object)
            .maybeSingle();
        if (res != null) return res['id_usuario'] as int;
      }
    } catch (_) {}
    return 1;
  }

  /// Sends all wizard data as a single JSON to the `crear_contrato_completo` RPC.
  Future<void> _submitWizard() async {
    if (_zonas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes agregar al menos una zona antes de confirmar.')));
      setState(() => _currentStep = 2);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final supabase = ref.read(supabaseClientProvider);
      final userId = await _getCurrentUserId();

      final payload = {
        if (_idContrato != null) 'id_contrato': _idContrato,
        'id_cliente': _idCliente,
        'numero_contrato': _numeroContratoCtrl.text.trim(),
        'nombre': _nombreCtrl.text.trim(),
        'fecha_firma': _fechaFirmaCtrl.text.trim().isEmpty ? null : _fechaFirmaCtrl.text.trim(),
        'fecha_inicio': _fechaInicioCtrl.text.trim(),
        'fecha_fin': _fechaFinCtrl.text.trim(),
        'moneda': _moneda,
        'monto_global': _montoGlobalCtrl.text.trim().isEmpty ? null : _montoGlobalCtrl.text.trim(),
        'periodicidad_facturacion': _periodicidad,
        'estatus': _estatus,
        'creado_por': userId,
        'actualizado_por': userId,
        'version': {
          if (_idContratoVersion != null) 'id_contrato_version': _idContratoVersion,
          'numero_version': _versionNumCtrl.text.trim(),
          'fecha_inicio_vigencia': _versionFechaInicioCtrl.text.trim(),
          'fecha_fin_vigencia': _versionFechaFinCtrl.text.trim(),
          'motivo_version': _versionDescCtrl.text.trim(),
        },
        'zonas': _zonas.map((z) => z.toJson()).toList(),
        'documentos': _documentos.map((d) => d.toJson()).toList(),
      };

      if (_idContrato != null) {
        await supabase.rpc('actualizar_contrato_completo', params: {'payload': payload});
      } else {
        await supabase.rpc('crear_contrato_completo', params: {'payload': payload});
      }

      // Refresh the contracts list
      ref.read(contratosProvider.notifier).fetchContratos();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('¡Contrato registrado exitosamente!'),
          backgroundColor: Colors.green,
        ));
        _resetWizard();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar el contrato: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.97,
        constraints: const BoxConstraints(maxWidth: 1150),
        height: MediaQuery.of(context).size.height * 0.88,
        color: context.surfaceColor,
        child: Column(
          children: [
            _buildHeader(),
            Divider(height: 1, color: context.borderColor),
            Expanded(child: _isCreating ? _buildWizard() : _buildListView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isCreating ? 'Nuevo Contrato' : 'Gestión de Contratos',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textColor),
              ),
              if (_isCreating)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 13, color: context.mutedTextColor),
                      const SizedBox(width: 4),
                      Text(
                        'Toda la información se guardará al terminar el último paso — si cancelas, no se guardará nada.',
                        style: TextStyle(fontSize: 11, color: context.mutedTextColor),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Row(
            children: [
              if (!_isCreating)
                ElevatedButton.icon(
                  onPressed: () => setState(() => _isCreating = true),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nuevo Contrato'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.close, color: context.textColor),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // List View
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildListView() {
    final contratosAsync = ref.watch(contratosProvider);
    final clientesAsync = ref.watch(clientesProvider);

    return contratosAsync.when(
      data: (contratos) {
        final active = contratos.where((c) => c.activo).toList();
        if (active.isEmpty) {
          return Center(
            child: Text('No hay contratos registrados.',
                style: TextStyle(color: context.mutedTextColor)),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ModalDataTable(dataTable: DataTable(
                columns: [
                  DataColumn(label: Text('CLIENTE', style: TextStyle(color: context.mutedTextColor))),
                  DataColumn(label: Text('NO. CONTRATO', style: TextStyle(color: context.mutedTextColor))),
                  DataColumn(label: Text('VIGENCIA', style: TextStyle(color: context.mutedTextColor))),
                  DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
                  DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
                ],
                rows: active.map((c) {
                  String clientName = '—';
                  clientesAsync.whenData((list) {
                    final cl = list.where((cl) => cl.idCliente == c.idCliente).firstOrNull;
                    if (cl != null) clientName = cl.nombreComercial;
                  });
                  return DataRow(cells: [
                    DataCell(Text(clientName, style: TextStyle(color: context.textColor))),
                    DataCell(Text(c.numeroContrato, style: TextStyle(color: context.textColor))),
                    DataCell(Text('${c.fechaInicio} → ${c.fechaFin}',
                        style: TextStyle(color: context.textColor))),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: c.estatus == 'Vigente'
                            ? AppColors.green.withOpacity(0.15)
                            : AppColors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(c.estatus,
                          style: TextStyle(
                            color: c.estatus == 'Vigente' ? AppColors.green : AppColors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                    )),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                          onPressed: () => _openEditWizard(c),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: AppColors.red, size: 20),
                          onPressed: () => _deleteContratoDialog(c),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              )),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          Center(child: Text('Error: $e', style: TextStyle(color: AppColors.red))),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Stepper Wizard
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildWizard() {
    return Stepper(
      currentStep: _currentStep,
      type: StepperType.horizontal,
      controlsBuilder: (context, details) {
        final isLast = _currentStep == 4;
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : isLast
                        ? _submitWizard
                        : () => _tryAdvance(details),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLast ? AppColors.green : AppColors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving && isLast
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(isLast ? 'Confirmar y Guardar Todo' : 'Siguiente'),
              ),
              const SizedBox(width: 12),
              if (_currentStep > 0) ...[
                TextButton(
                  onPressed: _isSaving ? null : () => details.onStepCancel?.call(),
                  style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                  child: const Text('Atrás'),
                ),
                const SizedBox(width: 12),
              ],
              TextButton(
                onPressed: _isSaving ? null : _resetWizard,
                style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
      },
      onStepTapped: (step) {
        // Only allow tapping to already-seen steps
        if (step < _currentStep) setState(() => _currentStep = step);
      },
      onStepContinue: () => _tryAdvance(null),
      onStepCancel: () {
        if (_currentStep > 0) setState(() => _currentStep--);
      },
      steps: [
        Step(
          title: const Text('Contrato'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          content: _buildStep1(),
        ),
        Step(
          title: const Text('Versión'),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          content: _buildStep2(),
        ),
        Step(
          title: const Text('Zonas'),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          content: _buildStep3(),
        ),
        Step(
          title: const Text('Alcance y SLA'),
          isActive: _currentStep >= 3,
          state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          content: _buildStep4(),
        ),
        Step(
          title: const Text('Documentos'),
          isActive: _currentStep >= 4,
          state: StepState.indexed,
          content: _buildStep5(),
        ),
      ],
    );
  }

  void _tryAdvance(ControlsDetails? details) {
    bool valid = true;
    if (_currentStep == 0) valid = _step1Key.currentState?.validate() ?? false;
    if (_currentStep == 1) valid = _step2Key.currentState?.validate() ?? false;

    if (valid) {
      setState(() => _currentStep++);
    }
  }

  // ── Step 1: Datos Generales del Contrato ──────────────────────────────────

  Widget _buildStep1() {
    final clientesAsync = ref.watch(clientesProvider);

    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          clientesAsync.when(
            data: (clientes) {
              final active = clientes.where((c) => c.activo).toList();
              return DropdownButtonFormField<int>(
                value: _idCliente,
                decoration: _inputDeco('Cliente *'),
                dropdownColor: context.surfaceColor,
                style: TextStyle(color: context.textColor),
                items: active
                    .map((c) => DropdownMenuItem(
                        value: c.idCliente,
                        child: Text('${c.codigo} — ${c.nombreComercial}',
                            style: TextStyle(color: context.textColor))))
                    .toList(),
                onChanged: (v) => setState(() => _idCliente = v),
                validator: (v) => v == null ? 'Selecciona un cliente' : null,
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(flex: 1, child: _textField('Número de Contrato *', _numeroContratoCtrl, required: true)),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: _textField('Nombre / Descripción *', _nombreCtrl, required: true)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _dateField('Fecha de Firma', _fechaFirmaCtrl)),
            const SizedBox(width: 16),
            Expanded(child: _dateField('Fecha Inicio *', _fechaInicioCtrl, required: true)),
            const SizedBox(width: 16),
            Expanded(child: _dateField('Fecha Fin *', _fechaFinCtrl, required: true)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _moneda,
                decoration: _inputDeco('Moneda'),
                dropdownColor: context.surfaceColor,
                style: TextStyle(color: context.textColor),
                items: ['MXN', 'USD']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(color: context.textColor))))
                    .toList(),
                onChanged: (v) => setState(() => _moneda = v!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: _textField('Monto Global', _montoGlobalCtrl,
                    keyboardType: TextInputType.number)),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _periodicidad,
                decoration: _inputDeco('Periodicidad Facturación'),
                dropdownColor: context.surfaceColor,
                style: TextStyle(color: context.textColor),
                items: ['Mensual', 'Bimestral', 'Trimestral', 'Semestral', 'Anual']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(color: context.textColor))))
                    .toList(),
                onChanged: (v) => setState(() => _periodicidad = v!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _estatus,
                decoration: _inputDeco('Estatus'),
                dropdownColor: context.surfaceColor,
                style: TextStyle(color: context.textColor),
                items: ['Vigente', 'Vencido', 'Cancelado']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(color: context.textColor))))
                    .toList(),
                onChanged: (v) => setState(() => _estatus = v!),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // ── Step 2: Versión Inicial ───────────────────────────────────────────────

  Widget _buildStep2() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
                flex: 1,
                child: _textField('No. Versión *', _versionNumCtrl,
                    required: true, keyboardType: TextInputType.number, readOnly: true)),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: _textField('Descripción', _versionDescCtrl)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: _dateField('Fecha Inicio Vigencia *', _versionFechaInicioCtrl,
                    required: true)),
            const SizedBox(width: 16),
            Expanded(child: _dateField('Fecha Fin Vigencia', _versionFechaFinCtrl)),
          ]),
        ],
      ),
    );
  }

  // ── Step 3: Zonas Geográficas ─────────────────────────────────────────────

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._zonas.asMap().entries.map((entry) {
          final idx = entry.key;
          final zona = entry.value;
          return _buildZonaCard(idx, zona);
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => setState(() => _zonas.add(_ZonaData())),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Zona'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.blue),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => _mostrarDialogoZonasUnicas(context),
              icon: const Icon(Icons.search),
              label: const Text('Importar Existente'),
              style: OutlinedButton.styleFrom(foregroundColor: context.textColor),
            ),
          ],
        ),
        if (_zonas.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('* Agrega al menos una zona geográfica para continuar.',
                style: TextStyle(color: AppColors.red, fontSize: 12)),
          ),
      ],
    );
  }

  void _mostrarDialogoZonasUnicas(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: context.surfaceColor,
          title: Text('Importar Zona Existente', style: TextStyle(color: context.textColor)),
          content: SizedBox(
            width: 400,
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(helperZonasContratoUnicasProvider);
                return state.when(
                  data: (zonas) {
                    if (zonas.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('No hay zonas previas registradas.', style: TextStyle(color: context.mutedTextColor)),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: zonas.length,
                      itemBuilder: (context, index) {
                        final z = zonas[index];
                        return ListTile(
                          title: Text('${z['codigo']} - ${z['nombre']}', style: TextStyle(color: context.textColor)),
                          subtitle: Text(z['descripcion'] ?? '', style: TextStyle(color: context.mutedTextColor)),
                          onTap: () {
                            setState(() {
                              _zonas.add(_ZonaData(
                                codigo: z['codigo'],
                                nombre: z['nombre'],
                                descripcion: z['descripcion'] ?? '',
                              ));
                            });
                            Navigator.of(ctx).pop();
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, st) => Text('Error al cargar zonas: $err', style: TextStyle(color: AppColors.red)),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildZonaCard(int idx, _ZonaData zona) {
    return Card(
      color: context.backgroundColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Zona ${idx + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: context.textColor)),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.red, size: 20),
                  onPressed: () => setState(() => _zonas.removeAt(idx)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: zona.codigo,
                  style: TextStyle(color: context.textColor),
                  decoration: _inputDeco('Código'),
                  onChanged: (v) => zona.codigo = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: zona.nombre,
                  style: TextStyle(color: context.textColor),
                  decoration: _inputDeco('Nombre *'),
                  onChanged: (v) => zona.nombre = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: zona.descripcion,
                  style: TextStyle(color: context.textColor),
                  decoration: _inputDeco('Descripción'),
                  onChanged: (v) => zona.descripcion = v,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ── Step 4: Alcances y SLAs ───────────────────────────────────────────────

  Widget _buildStep4() {
    if (_zonas.isEmpty) {
      return Text('⚠️ Primero define al menos una zona en el paso anterior.',
          style: TextStyle(color: AppColors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _zonas.asMap().entries.map((entry) {
        final idx = entry.key;
        final zona = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zona ${idx + 1}: ${zona.nombre}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                    fontSize: 15)),
            const SizedBox(height: 8),
            // SLA rows for this zone
            ...zona.slas.asMap().entries.map((slaEntry) {
              final si = slaEntry.key;
              final sla = slaEntry.value;
              return _buildSlaRow(zona, si, sla);
            }),
            OutlinedButton.icon(
              onPressed: () => setState(() => zona.slas.add(_SlaData())),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Agregar SLA'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
            ),
            const Divider(height: 24),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSlaRow(_ZonaData zona, int si, _SlaData sla) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: sla.prioridad,
              decoration: _inputDeco('Prioridad'),
              dropdownColor: context.surfaceColor,
              style: TextStyle(color: context.textColor),
              items: ['Alta', 'Media', 'Baja', 'Crítica']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(color: context.textColor))))
                  .toList(),
              onChanged: (v) => setState(() => sla.prioridad = v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: sla.horarioCobertura,
              style: TextStyle(color: context.textColor),
              decoration: _inputDeco('Horario (ej: 8x5)'),
              onChanged: (v) => sla.horarioCobertura = v,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: sla.minutosRespuesta,
              style: TextStyle(color: context.textColor),
              decoration: _inputDeco('Min. Respuesta *'),
              keyboardType: TextInputType.number,
              onChanged: (v) => sla.minutosRespuesta = v,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: sla.minutosLlegada,
              style: TextStyle(color: context.textColor),
              decoration: _inputDeco('Min. Llegada'),
              keyboardType: TextInputType.number,
              onChanged: (v) => sla.minutosLlegada = v,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: sla.minutosSolucion,
              style: TextStyle(color: context.textColor),
              decoration: _inputDeco('Min. Solución'),
              keyboardType: TextInputType.number,
              onChanged: (v) => sla.minutosSolucion = v,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: AppColors.red, size: 20),
            onPressed: () => setState(() => zona.slas.removeAt(si)),
          ),
        ],
      ),
    );
  }

  // ── Step 5: Documentos ────────────────────────────────────────────────────

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registra los documentos que forman parte de este contrato (opcional).',
          style: TextStyle(color: context.mutedTextColor, fontSize: 13),
        ),
        const SizedBox(height: 12),
        ..._documentos.asMap().entries.map((entry) {
          final idx = entry.key;
          final doc = entry.value;
          return _buildDocumentoCard(idx, doc);
        }),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => setState(() => _documentos.add(_DocumentoData())),
          icon: const Icon(Icons.add),
          label: const Text('Agregar Documento'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.blue),
        ),
      ],
    );
  }

  Widget _buildDocumentoCard(int idx, _DocumentoData doc) {
    return Card(
      color: context.backgroundColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Documento ${idx + 1}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: context.textColor)),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.red, size: 20),
                  onPressed: () => setState(() => _documentos.removeAt(idx)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: doc.tipoDocumento,
                  decoration: _inputDeco('Tipo'),
                  dropdownColor: context.surfaceColor,
                  style: TextStyle(color: context.textColor),
                  items: ['Contrato Principal', 'Anexo', 'Addendum', 'SLA', 'Otro']
                      .map((s) => DropdownMenuItem(
                          value: s, child: Text(s, style: TextStyle(color: context.textColor))))
                      .toList(),
                  onChanged: (v) => setState(() => doc.tipoDocumento = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: doc.nombreArchivo,
                  style: TextStyle(color: context.textColor),
                  decoration: _inputDeco('Nombre Archivo *'),
                  onChanged: (v) => doc.nombreArchivo = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _uploadFile(doc),
                      icon: const Icon(Icons.upload_file, size: 16),
                      label: const Text('Subir Archivo'),
                    ),
                    if (doc.rutaArchivo.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _downloadFile(doc),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Descargar'),
                      ),
                    ]
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(text: doc.hashSha256),
                  readOnly: true,
                  style: TextStyle(color: context.textColor),
                  decoration: _inputDeco('Hash SHA-256'),
                  maxLength: 64,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(text: doc.fechaDocumento),
                        readOnly: true,
                        style: TextStyle(color: context.textColor),
                        decoration: _inputDeco('Fecha Documento (YYYY-MM-DD)').copyWith(
                          suffixIcon: Icon(Icons.calendar_today, size: 16, color: context.mutedTextColor),
                        ),
                        onTap: () async {
                           final picked = await showDatePicker(
                             context: context,
                             initialDate: doc.fechaDocumento.isNotEmpty
                                 ? DateTime.tryParse(doc.fechaDocumento) ?? DateTime.now()
                                 : DateTime.now(),
                             firstDate: DateTime(2000),
                             lastDate: DateTime(2150),
                           );
                           if (picked != null && mounted) {
                             setState(() {
                               doc.fechaDocumento = picked.toIso8601String().split('T').first;
                             });
                           }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Vigente', style: TextStyle(color: context.textColor)),
                    Switch(
                      value: doc.esVigente,
                      onChanged: (v) => setState(() => doc.esVigente = v),
                      activeColor: AppColors.green,
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadFile(_DocumentoData doc) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = result.files.first;
        if (file.bytes == null) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se puede leer el archivo.')));
           return;
        }
        
        setState(() => _isSaving = true);
        
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:8001/api/v1/contratos/documentos/upload'),
        );
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ));

        var response = await request.send();
        if (response.statusCode == 201 || response.statusCode == 200) {
          final resStr = await response.stream.bytesToString();
          final data = jsonDecode(resStr);
          setState(() {
            doc.rutaArchivo = data['ruta'];
            doc.hashSha256 = data['hash'];
            if (doc.nombreArchivo.isEmpty) {
              doc.nombreArchivo = file.name;
            }
          });
        } else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir: ${response.statusCode}')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir el archivo: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _downloadFile(_DocumentoData doc) async {
     try {
        final response = await http.get(Uri.parse('http://localhost:8001/api/v1/contratos/documentos/download?ruta=${Uri.encodeComponent(doc.rutaArchivo)}'));
        if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final url = data['url'];
            if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            }
        } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo obtener el enlace de descarga.')));
        }
     } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al descargar: $e')));
     }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared field helpers
  // ─────────────────────────────────────────────────────────────────────────

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: context.mutedTextColor, fontSize: 13),
      isDense: true,
      filled: true,
      fillColor: context.surfaceColor,
      counterText: '',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.borderColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.blue, width: 1.5)),
    );
  }

  Widget _textField(String label, TextEditingController ctrl,
      {bool required = false,
      TextInputType keyboardType = TextInputType.text,
      int? maxLength,
      bool readOnly = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLength: maxLength,
      readOnly: readOnly,
      style: TextStyle(color: context.textColor),
      decoration: _inputDeco(label),
      validator:
          required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
    );
  }

  Widget _dateField(String label, TextEditingController ctrl,
      {bool required = false}) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      style: TextStyle(color: context.textColor),
      decoration: _inputDeco(label).copyWith(
        suffixIcon: Icon(Icons.calendar_today, size: 16, color: context.mutedTextColor),
      ),
      onTap: () => _pickDate(ctrl),
      validator:
          required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
    );
  }
}
