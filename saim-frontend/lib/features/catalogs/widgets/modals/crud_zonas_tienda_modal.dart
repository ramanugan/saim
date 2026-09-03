import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/zona_tienda.dart';
import '../../providers/zonas_tienda_provider.dart';
import '../../providers/zonas_provider.dart';
import '../../providers/tiendas_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudZonasTiendaModal extends ConsumerStatefulWidget {
  const CrudZonasTiendaModal({super.key});

  @override
  ConsumerState<CrudZonasTiendaModal> createState() => _CrudZonasTiendaModalState();
}

class _CrudZonasTiendaModalState extends ConsumerState<CrudZonasTiendaModal> {
  bool _isEditing = false;
  ZonaTienda? _selectedZona;

  final _formKey = GlobalKey<FormState>();
  int? _idZona;
  int? _idTienda;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  late TextEditingController _numeroAnexoCtrl;
  String _estatus = 'Activo';

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idZona = _selectedZona?.idZona;
    _idTienda = _selectedZona?.idTienda;
    _fechaInicioCtrl = TextEditingController(
        text: _selectedZona != null
            ? _selectedZona!.fechaInicioCobertara.toIso8601String().split('T').first
            : DateTime.now().toIso8601String().split('T').first);
    _fechaFinCtrl = TextEditingController(
        text: _selectedZona?.fechaFinCobertura
                ?.toIso8601String()
                .split('T')
                .first ??
            '');
    _numeroAnexoCtrl =
        TextEditingController(text: _selectedZona?.numeroAnexo ?? '');
    _estatus = _selectedZona?.estatus ?? 'Activo';
  }

  @override
  void dispose() {
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _numeroAnexoCtrl.dispose();
    super.dispose();
  }

  void _openForm([ZonaTienda? zona]) {
    setState(() {
      _selectedZona = zona;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedZona = null;
    });
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ctrl.text.isNotEmpty
          ? DateTime.tryParse(ctrl.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ctrl.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final newZona = ZonaTienda(
      idZonaTienda: _selectedZona?.idZonaTienda,
      idZona: _idZona ?? 0,
      idTienda: _idTienda ?? 0,
      fechaInicioCobertara:
          DateTime.tryParse(_fechaInicioCtrl.text.trim()) ?? DateTime.now(),
      fechaFinCobertura: _fechaFinCtrl.text.trim().isNotEmpty
          ? DateTime.tryParse(_fechaFinCtrl.text.trim())
          : null,
      numeroAnexo: _numeroAnexoCtrl.text.trim().isEmpty
          ? null
          : _numeroAnexoCtrl.text.trim(),
      estatus: _estatus,
      activo: _selectedZona?.activo ?? true,
    );

    try {
      if (_selectedZona == null) {
        await ref.read(zonasTiendaProvider.notifier).addZonaTienda(newZona);
      } else {
        await ref.read(zonasTiendaProvider.notifier).updateZonaTienda(newZona);
      }
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteZona(ZonaTienda zona) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Zona Tienda'),
        content: const Text('¿Estás seguro de eliminar este registro de Zona Tienda?'),
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
    if (confirm == true && zona.idZonaTienda != null) {
      try {
        await ref
            .read(zonasTiendaProvider.notifier)
            .deleteZonaTienda(zona.idZonaTienda!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
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
        height: 620,
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
                        ? (_selectedZona == null
                            ? 'Nueva Zona Tienda'
                            : 'Editar Zona Tienda')
                        : 'Gestión de Zona Tienda',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.borderColor),
            Expanded(
              child: _isEditing ? _buildForm() : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final zonasAsync = ref.watch(zonasTiendaProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar Zona Tienda'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: zonasAsync.when(
            data: (zonas) {
              if (zonas.isEmpty) {
                return Center(
                  child: Text('No hay registros de Zona Tienda.',
                      style: TextStyle(color: context.mutedTextColor)),
                );
              }
              return ModalDataTable(dataTable: DataTable(
                    columns: [
                      DataColumn(label: Text('ID ZONA', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('ID TIENDA', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('INICIO COBERTURA', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('FIN COBERTURA', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('ESTATUS', style: TextStyle(color: context.mutedTextColor))),
                      DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
                    ],
                    rows: zonas.map((z) => DataRow(
                      cells: [
                        DataCell(Text(z.idZona.toString(), style: TextStyle(color: context.textColor))),
                        DataCell(Text(z.idTienda.toString(), style: TextStyle(color: context.textColor))),
                        DataCell(Text(z.fechaInicioCobertara.toIso8601String().split('T').first, style: TextStyle(color: context.textColor))),
                        DataCell(Text(z.fechaFinCobertura?.toIso8601String().split('T').first ?? '—', style: TextStyle(color: context.textColor))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: z.estatus == 'Activo'
                                ? AppColors.green.withOpacity(0.15)
                                : AppColors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            z.estatus,
                            style: TextStyle(
                              color: z.estatus == 'Activo' ? AppColors.green : AppColors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                              onPressed: () => _openForm(z),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: AppColors.red, size: 20),
                              onPressed: () => _deleteZona(z),
                            ),
                          ],
                        )),
                      ],
                    )).toList(),
                  ));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                Center(child: Text('Error: $e', style: TextStyle(color: AppColors.red))),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final zonasAsync = ref.watch(helperZonasProvider);
    final tiendasAsync = ref.watch(helperTiendasProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _idZona,
                    decoration: InputDecoration(
                      labelText: 'Zona *',
                      labelStyle: TextStyle(color: context.textColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: context.backgroundColor,
                    ),
                    dropdownColor: context.surfaceColor,
                    style: TextStyle(color: context.textColor),
                    isExpanded: true,
                    items: zonasAsync.when(
                      data: (list) => list.map((item) {
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(item['nombre'], overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      loading: () => [],
                      error: (_, __) => [],
                    ),
                    onChanged: (v) => setState(() => _idZona = v),
                    validator: (v) => v == null ? 'Requerido' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _idTienda,
                    decoration: InputDecoration(
                      labelText: 'Tienda *',
                      labelStyle: TextStyle(color: context.textColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: context.backgroundColor,
                    ),
                    dropdownColor: context.surfaceColor,
                    style: TextStyle(color: context.textColor),
                    isExpanded: true,
                    items: tiendasAsync.when(
                      data: (list) => list.map((item) {
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(item['nombre'], overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      loading: () => [],
                      error: (_, __) => [],
                    ),
                    onChanged: (v) => setState(() => _idTienda = v),
                    validator: (v) => v == null ? 'Requerido' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateField('Fecha Inicio Cobertura *', _fechaInicioCtrl, required: true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField('Fecha Fin Cobertura', _fechaFinCtrl),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Número de Anexo', _numeroAnexoCtrl, maxLength: 100),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _estatus,
              decoration: InputDecoration(
                labelText: 'Estatus',
                labelStyle: TextStyle(color: context.textColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: context.backgroundColor,
              ),
              dropdownColor: context.surfaceColor,
              style: TextStyle(color: context.textColor),
              items: {'Activo', 'Inactivo', 'Pendiente', 'VIGENTE', 'Vigente', _estatus}
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _estatus = v!),
            ),
            const SizedBox(height: 32),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool required = false, int? maxLength, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          validator: required
              ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller,
      {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            suffixIcon: Icon(Icons.calendar_today, size: 18, color: context.mutedTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          onTap: () => _pickDate(controller),
          validator: required
              ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null
              : null,
        ),
      ],
    );
  }
}
