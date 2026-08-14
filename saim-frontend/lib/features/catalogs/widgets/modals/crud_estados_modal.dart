import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/estado.dart';
import '../../providers/estados_provider.dart';
import '../../providers/paises_provider.dart';

class CrudEstadosModal extends ConsumerStatefulWidget {
  const CrudEstadosModal({super.key});

  @override
  ConsumerState<CrudEstadosModal> createState() => _CrudEstadosModalState();
}

class _CrudEstadosModalState extends ConsumerState<CrudEstadosModal> {
  bool _isEditing = false;
  Estado? _selectedEstado;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _claveInegiCtrl;

  int? _selectedPaisId;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nombreCtrl = TextEditingController(text: _selectedEstado?.nombre ?? '');
    _claveInegiCtrl = TextEditingController(text: _selectedEstado?.claveInegi ?? '');
    _selectedPaisId = _selectedEstado?.idPais;
    _activo = _selectedEstado?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _claveInegiCtrl.dispose();
    super.dispose();
  }

  void _openForm([Estado? estado]) {
    setState(() {
      _selectedEstado = estado;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedEstado = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPaisId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, selecciona un país.')));
      return;
    }
    
    final newEstado = Estado(
      idEstado: _selectedEstado?.idEstado,
      idPais: _selectedPaisId!,
      nombre: _nombreCtrl.text.trim(),
      claveInegi: _claveInegiCtrl.text.trim().isEmpty ? null : _claveInegiCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedEstado == null) {
        await ref.read(estadosProvider.notifier).addEstado(newEstado);
      } else {
        await ref.read(estadosProvider.notifier).updateEstado(newEstado);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Estado estado) async {
    final action = estado.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${estado.activo ? 'Desactivar' : 'Activar'} Estado'),
        content: Text('¿Estás seguro de que deseas $action este estado?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(estado.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && estado.idEstado != null) {
      try {
        await ref.read(estadosProvider.notifier).toggleStatus(estado.idEstado!, estado.activo);
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
        constraints: BoxConstraints(maxWidth: 800),
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
                    _isEditing ? (_selectedEstado == null ? 'Nuevo Estado' : 'Editar Estado') : 'Gestión de Estados',
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
                          icon: Icon(Icons.add, size: 18),
                          label: Text('Agregar Estado'),
                        ),
                      SizedBox(width: 16),
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
    final estadosAsync = ref.watch(estadosProvider);

    return estadosAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (estados) {
        if (estados.isEmpty) {
          return Center(
            child: Text('No hay estados registrados.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CLAVE INEGI', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: estados.map((e) => DataRow(
                cells: [
                  DataCell(Text(e.nombre, style: TextStyle(color: context.textColor))),
                  DataCell(Text(e.claveInegi ?? '', style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: e.activo ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        e.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: e.activo ? AppColors.green : AppColors.red,
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
                        icon: Icon(Icons.edit, color: AppColors.blue, size: 20),
                        onPressed: () => _openForm(e),
                      ),
                      IconButton(
                        icon: Icon(e.activo ? Icons.block : Icons.check_circle_outline, color: e.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(e),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaisDropdown(),
              SizedBox(height: 16),
              _buildTextField('Nombre *', _nombreCtrl, required: true),
              SizedBox(height: 16),
              _buildTextField('Clave INEGI', _claveInegiCtrl),
              SizedBox(height: 24),
              Row(
                children: [
                  Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Switch(
                    value: _activo,
                    onChanged: (val) => setState(() => _activo = val),
                    activeColor: AppColors.green,
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _closeForm,
                    style: TextButton.styleFrom(foregroundColor: context.mutedTextColor),
                    child: Text('Cancelar'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Guardar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaisDropdown() {
    // Import paises_provider internally or from top
    // For now we assume we need to add the import at the top
    final paisesAsync = ref.watch(paisesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('País *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        paisesAsync.when(
          loading: () => CircularProgressIndicator(),
          error: (err, st) => Text('Error: $err', style: TextStyle(color: AppColors.red)),
          data: (paises) {
            final activePaises = paises.where((p) => p.activo).toList();
            if (activePaises.isEmpty && _selectedPaisId == null) {
              return Text('No hay países activos', style: TextStyle(color: context.mutedTextColor));
            }
            return DropdownButtonFormField<int>(
              value: _selectedPaisId,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: context.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.borderColor),
                ),
              ),
              dropdownColor: context.surfaceColor,
              items: activePaises.map((p) => DropdownMenuItem<int>(
                value: p.idPais,
                child: Text(p.nombre, style: TextStyle(color: context.textColor)),
              )).toList(),
              onChanged: (val) {
                setState(() => _selectedPaisId = val);
              },
              validator: (v) => v == null ? 'Requerido' : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
          validator: required ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
        ),
      ],
    );
  }
}
