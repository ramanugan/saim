import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/contrato.dart';
import '../../providers/contratos_provider.dart';
import '../../providers/clientes_provider.dart';

class CrudContratosModal extends ConsumerStatefulWidget {
  const CrudContratosModal({super.key});

  @override
  ConsumerState<CrudContratosModal> createState() => _CrudContratosModalState();
}

class _CrudContratosModalState extends ConsumerState<CrudContratosModal> {
  bool _isEditing = false;
  Contrato? _selectedContrato;

  final _formKey = GlobalKey<FormState>();
  int? _idCliente;
  late TextEditingController _numeroContratoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _fechaFirmaCtrl;
  late TextEditingController _fechaInicioCtrl;
  late TextEditingController _fechaFinCtrl;
  late TextEditingController _montoGlobalCtrl;
  String _moneda = 'MXN';
  String _periodicidad = 'Mensual';
  String _estatus = 'Vigente';

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _idCliente = _selectedContrato?.idCliente;
    _numeroContratoCtrl = TextEditingController(text: _selectedContrato?.numeroContrato ?? '');
    _nombreCtrl = TextEditingController(text: _selectedContrato?.nombre ?? '');
    _fechaFirmaCtrl = TextEditingController(text: _selectedContrato?.fechaFirma ?? '');
    _fechaInicioCtrl = TextEditingController(text: _selectedContrato?.fechaInicio ?? '');
    _fechaFinCtrl = TextEditingController(text: _selectedContrato?.fechaFin ?? '');
    _montoGlobalCtrl = TextEditingController(text: _selectedContrato?.montoGlobal?.toString() ?? '');
    _moneda = _selectedContrato?.moneda ?? 'MXN';
    _periodicidad = _selectedContrato?.periodicidadFacturacion ?? 'Mensual';
    _estatus = _selectedContrato?.estatus ?? 'Vigente';
  }

  @override
  void dispose() {
    _numeroContratoCtrl.dispose();
    _nombreCtrl.dispose();
    _fechaFirmaCtrl.dispose();
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _montoGlobalCtrl.dispose();
    super.dispose();
  }

  void _openForm([Contrato? contrato]) {
    setState(() {
      _selectedContrato = contrato;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedContrato = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idCliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Debe seleccionar un cliente')));
      return;
    }
    
    final newContrato = Contrato(
      idContrato: _selectedContrato?.idContrato,
      idCliente: _idCliente!,
      numeroContrato: _numeroContratoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      fechaFirma: _fechaFirmaCtrl.text.trim().isEmpty ? null : _fechaFirmaCtrl.text.trim(),
      fechaInicio: _fechaInicioCtrl.text.trim(),
      fechaFin: _fechaFinCtrl.text.trim(),
      moneda: _moneda,
      montoGlobal: double.tryParse(_montoGlobalCtrl.text.trim()),
      periodicidadFacturacion: _periodicidad,
      estatus: _estatus,
      activo: _selectedContrato?.activo ?? true,
    );

    try {
      if (_selectedContrato == null) {
        await ref.read(contratosProvider.notifier).addContrato(newContrato);
      } else {
        await ref.read(contratosProvider.notifier).updateContrato(newContrato);
      }
      _closeForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteContrato(Contrato contrato) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar Contrato'),
        content: Text('¿Estás seguro de eliminar el contrato ${contrato.numeroContrato}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ref.read(contratosProvider.notifier).deleteContrato(contrato.idContrato!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(maxWidth: 1100),
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
                    _isEditing ? (_selectedContrato == null ? 'Nuevo Contrato' : 'Editar Contrato') : 'Gestión de Contratos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.textColor),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            Expanded(
              child: _isEditing ? _buildForm() : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final contratosAsync = ref.watch(contratosProvider);
    final clientesAsync = ref.watch(clientesProvider);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openForm(),
                icon: Icon(Icons.add, size: 18),
                label: Text('Agregar Contrato'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: contratosAsync.when(
            data: (contratos) {
              final activeContratos = contratos.where((c) => c.activo).toList();
              if (activeContratos.isEmpty) {
                return Center(child: Text('No hay contratos registrados', style: TextStyle(color: context.mutedTextColor)));
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('CLIENTE')),
                      DataColumn(label: Text('NO. CONTRATO')),
                      DataColumn(label: Text('VIGENCIA')),
                      DataColumn(label: Text('ESTATUS')),
                      DataColumn(label: Text('ACCIONES')),
                    ],
                    rows: activeContratos.map((c) {
                      String clientName = 'Cargando...';
                      clientesAsync.whenData((clientesList) {
                        final cl = clientesList.where((cli) => cli.idCliente == c.idCliente).firstOrNull;
                        if (cl != null) clientName = cl.nombreComercial;
                        else clientName = 'Desc.';
                      });
                      
                      return DataRow(
                      cells: [
                        DataCell(Text(clientName)),
                        DataCell(Text(c.numeroContrato)),
                        DataCell(Text('${c.fechaInicio} al ${c.fechaFin}')),
                        DataCell(Text(c.estatus)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: 18, color: AppColors.blue),
                              onPressed: () => _openForm(c),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: () => _deleteContrato(c),
                            ),
                          ],
                        )),
                      ]
                    );
                    }).toList(),
                  ),
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    final clientesAsync = ref.watch(clientesProvider);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            clientesAsync.when(
              data: (clientes) {
                final activos = clientes.where((c) => c.activo).toList();
                return DropdownButtonFormField<int>(
                  value: _idCliente,
                  decoration: InputDecoration(labelText: 'Cliente (Obligatorio)', border: OutlineInputBorder()),
                  items: activos.map((c) => DropdownMenuItem(value: c.idCliente, child: Text(c.nombreComercial))).toList(),
                  onChanged: (v) => setState(() => _idCliente = v),
                  validator: (v) => v == null ? 'Requerido' : null,
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (e, st) => Text('Error al cargar clientes'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _numeroContratoCtrl,
              decoration: InputDecoration(labelText: 'Número de Contrato (Obligatorio)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration: InputDecoration(labelText: 'Nombre / Descripción (Obligatorio)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _fechaFirmaCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha Firma', 
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(icon: Icon(Icons.calendar_today), onPressed: () => _selectDate(_fechaFirmaCtrl)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _fechaInicioCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha Inicio (Obligatorio)', 
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(icon: Icon(Icons.calendar_today), onPressed: () => _selectDate(_fechaInicioCtrl)),
                    ),
                    validator: (v) => v!.isEmpty ? 'Requerido' : null,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _fechaFinCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha Fin (Obligatorio)', 
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(icon: Icon(Icons.calendar_today), onPressed: () => _selectDate(_fechaFinCtrl)),
                    ),
                    validator: (v) => v!.isEmpty ? 'Requerido' : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _moneda,
                    decoration: InputDecoration(labelText: 'Moneda', border: OutlineInputBorder()),
                    items: ['MXN', 'USD'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _moneda = v!),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _montoGlobalCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Monto Global', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _periodicidad,
                    decoration: InputDecoration(labelText: 'Periodicidad Facturación', border: OutlineInputBorder()),
                    items: ['Mensual', 'Bimestral', 'Trimestral', 'Anual'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _periodicidad = v!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _estatus,
              decoration: InputDecoration(labelText: 'Estatus', border: OutlineInputBorder()),
              items: ['Vigente', 'Vencido', 'Cancelado'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _estatus = v!),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _closeForm, child: Text('Cancelar')),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
