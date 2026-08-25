import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/pais.dart';
import '../../providers/paises_provider.dart';
import '../../../../shared/widgets/modal_data_table.dart';

class CrudPaisesModal extends ConsumerStatefulWidget {
  const CrudPaisesModal({super.key});

  @override
  ConsumerState<CrudPaisesModal> createState() => _CrudPaisesModalState();
}

class _CrudPaisesModalState extends ConsumerState<CrudPaisesModal> {
  bool _isEditing = false;
  Pais? _selectedPais;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoIsoCtrl;
  late TextEditingController _nombreCtrl;
  bool _activo = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _codigoIsoCtrl = TextEditingController(text: _selectedPais?.codigoIso ?? '');
    _nombreCtrl = TextEditingController(text: _selectedPais?.nombre ?? '');
    _activo = _selectedPais?.activo ?? true;
  }

  @override
  void dispose() {
    _codigoIsoCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _openForm([Pais? pais]) {
    setState(() {
      _selectedPais = pais;
      _initControllers();
      _isEditing = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isEditing = false;
      _selectedPais = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    final newPais = Pais(
      idPais: _selectedPais?.idPais,
      codigoIso: _codigoIsoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      activo: _activo,
    );

    try {
      if (_selectedPais == null) {
        await ref.read(paisesProvider.notifier).addPais(newPais);
      } else {
        await ref.read(paisesProvider.notifier).updatePais(newPais);
      }
      _closeForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _toggleStatus(Pais pais) async {
    final action = pais.activo ? 'desactivar' : 'activar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${pais.activo ? 'Desactivar' : 'Activar'} País'),
        content: Text('¿Estás seguro de que deseas $action este país?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(pais.activo ? 'Desactivar' : 'Activar')
          ),
        ],
      ),
    );

    if (confirm == true && pais.idPais != null) {
      try {
        await ref.read(paisesProvider.notifier).toggleStatus(pais.idPais!, pais.activo);
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
                    _isEditing ? (_selectedPais == null ? 'Nuevo País' : 'Editar País') : 'Gestión de Países',
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
                          label: Text('Agregar País'),
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
    final paisesAsync = ref.watch(paisesProvider);

    return paisesAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.red))),
      data: (paises) {
        if (paises.isEmpty) {
          return Center(
            child: Text('No hay registros de países.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        return ModalDataTable(dataTable: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CÓDIGO ISO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('NOMBRE', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ESTADO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ACCIONES', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: paises.map((p) => DataRow(
                cells: [
                  DataCell(Text(p.idPais.toString(), style: TextStyle(color: context.textColor))),
                  DataCell(Text(p.codigoIso, style: TextStyle(color: context.textColor))),
                  DataCell(Text(p.nombre, style: TextStyle(color: context.textColor))),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.activo ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        p.activo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: p.activo ? AppColors.green : AppColors.red,
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
                        onPressed: () => _openForm(p),
                      ),
                      IconButton(
                        icon: Icon(p.activo ? Icons.block : Icons.check_circle_outline, color: p.activo ? AppColors.red : AppColors.green, size: 20),
                        onPressed: () => _toggleStatus(p),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildTextField('Código ISO (3 chars) *', _codigoIsoCtrl, required: true, maxLength: 3),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: _buildTextField('Nombre *', _nombreCtrl, required: true, maxLength: 120),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Activo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: context.textColor),
          maxLength: maxLength,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: context.backgroundColor,
            counterText: "",
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
