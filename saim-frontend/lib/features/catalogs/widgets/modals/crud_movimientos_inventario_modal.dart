import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/movimiento_inventario.dart';
import '../../providers/movimientos_inventario_provider.dart';

class CrudMovimientosInventarioModal extends ConsumerStatefulWidget {
  const CrudMovimientosInventarioModal({super.key});

  @override
  ConsumerState<CrudMovimientosInventarioModal> createState() => _CrudMovimientosInventarioModalState();
}

class _CrudMovimientosInventarioModalState extends ConsumerState<CrudMovimientosInventarioModal> {
  bool _isAdding = false;

  final _formKey = GlobalKey<FormState>();

  int? _selectedAlmacenId;
  int? _selectedRefaccionId;
  String _selectedTipoMovimiento = 'ENTRADA COMPRA';
  late TextEditingController _cantidadCtrl;
  late TextEditingController _referenciaCtrl;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _selectedAlmacenId = null;
    _selectedRefaccionId = null;
    _selectedTipoMovimiento = 'ENTRADA COMPRA';
    _cantidadCtrl = TextEditingController(text: '0.00');
    _referenciaCtrl = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _cantidadCtrl.dispose();
    _referenciaCtrl.dispose();
    super.dispose();
  }

  void _openForm() {
    setState(() {
      _initControllers();
      _isAdding = true;
    });
  }

  void _closeForm() {
    setState(() {
      _isAdding = false;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAlmacenId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona un Almacén')));
      return;
    }
    if (_selectedRefaccionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor selecciona una Refacción')));
      return;
    }

    final movimiento = MovimientoInventario(
      idAlmacen: _selectedAlmacenId!,
      idRefaccion: _selectedRefaccionId!,
      tipoMovimiento: _selectedTipoMovimiento,
      cantidad: double.tryParse(_cantidadCtrl.text) ?? 0.0,
      referenciaEntidad: _referenciaCtrl.text.trim().isEmpty ? null : _referenciaCtrl.text.trim(),
    );

    try {
      await ref.read(movimientosInventarioProvider.notifier).addMovimiento(movimiento);
      _closeForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                    _isAdding ? 'Registrar Movimiento de Inventario' : 'Historial de Movimientos de Inventario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.textColor),
                  ),
                  Row(
                    children: [
                      if (!_isAdding)
                        ElevatedButton.icon(
                          onPressed: _openForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Registrar Movimiento'),
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
              child: _isAdding ? _buildForm() : _buildTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    final listAsync = ref.watch(movimientosInventarioProvider);
    final almacenesAsync = ref.watch(helperAlmacenesForMovimientoProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForMovimientoProvider);

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.red))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text('No hay registros de movimientos de inventario.', style: TextStyle(color: context.mutedTextColor)),
          );
        }

        final almacenesMap = {
          for (var item in almacenesAsync.value ?? [])
            item['id_almacen'] as int: item['nombre'] as String
        };

        final refaccionesMap = {
          for (var item in refaccionesAsync.value ?? [])
            item['id_refaccion'] as int: '[${item['codigo_interno']}] ${item['descripcion_homologada']}'
        };

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('ALMACÉN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFACCIÓN', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('TIPO', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('CANTIDAD', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('FECHA HORA', style: TextStyle(color: context.mutedTextColor))),
                DataColumn(label: Text('REFERENCIA', style: TextStyle(color: context.mutedTextColor))),
              ],
              rows: list.map((item) {
                final isEntrada = item.tipoMovimiento == 'ENTRADA COMPRA' || item.tipoMovimiento == 'DEVOLUCION';
                final isSalida = item.tipoMovimiento == 'SALIDA_SERVICIO';
                Color amountColor = context.textColor;
                if (isEntrada) amountColor = AppColors.green;
                if (isSalida) amountColor = AppColors.red;

                return DataRow(
                  cells: [
                    DataCell(Text(item.idMovimiento.toString(), style: TextStyle(color: context.textColor))),
                    DataCell(Text(almacenesMap[item.idAlmacen] ?? 'ID: ${item.idAlmacen}', style: TextStyle(color: context.textColor))),
                    DataCell(Text(refaccionesMap[item.idRefaccion] ?? 'ID: ${item.idRefaccion}', style: TextStyle(color: context.textColor))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isEntrada
                              ? AppColors.green.withOpacity(0.2)
                              : isSalida
                                  ? AppColors.red.withOpacity(0.2)
                                  : AppColors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.tipoMovimiento,
                          style: TextStyle(
                            color: isEntrada
                                ? AppColors.green
                                : isSalida
                                    ? AppColors.red
                                    : AppColors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(
                      '${isEntrada ? "+" : isSalida ? "-" : ""}${item.cantidad.toStringAsFixed(2)}',
                      style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
                    )),
                    DataCell(Text(
                      item.fechaHora != null ? item.fechaHora!.toLocal().toString().split('.').first : '-',
                      style: TextStyle(color: context.textColor),
                    )),
                    DataCell(Text(item.referenciaEntidad ?? '-', style: TextStyle(color: context.textColor))),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    final almacenesAsync = ref.watch(helperAlmacenesForMovimientoProvider);
    final refaccionesAsync = ref.watch(helperRefaccionesForMovimientoProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Almacén & Refacción
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Almacén *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedAlmacenId,
                          style: TextStyle(color: context.textColor),
                          dropdownColor: context.surfaceColor,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: context.backgroundColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.borderColor)),
                          ),
                          items: (almacenesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item['id_almacen'] as int,
                              child: Text(item['nombre'] as String),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedAlmacenId = val),
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
                        Text('Refacción *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
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
                          items: (refaccionesAsync.value ?? []).map<DropdownMenuItem<int>>((item) {
                            final code = item['codigo_interno'] as String;
                            final name = item['descripcion_homologada'] as String;
                            return DropdownMenuItem<int>(
                              value: item['id_refaccion'] as int,
                              child: Text('[$code] $name', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedRefaccionId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Tipo Movimiento & Cantidad
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo Movimiento *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textColor)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedTipoMovimiento,
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
                            DropdownMenuItem<String>(value: 'ENTRADA COMPRA', child: Text('ENTRADA COMPRA')),
                            DropdownMenuItem<String>(value: 'SALIDA_SERVICIO', child: Text('SALIDA_SERVICIO')),
                            DropdownMenuItem<String>(value: 'TRANSFERENCIA', child: Text('TRANSFERENCIA')),
                            DropdownMenuItem<String>(value: 'AJUSTE', child: Text('AJUSTE')),
                            DropdownMenuItem<String>(value: 'DEVOLUCION', child: Text('DEVOLUCION')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedTipoMovimiento = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Cantidad *', _cantidadCtrl, required: true, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Referencia
              _buildTextField('Referencia ( Instalación Refacción / Orden Compra / Anexo / Servicio/ etc)', _referenciaCtrl),
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
                    child: const Text('Registrar'),
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
          validator: required
              ? (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  if (keyboardType?.decimal == true || keyboardType?.signed == true) {
                    final doubleVal = double.tryParse(v);
                    if (doubleVal == null || doubleVal <= 0) return 'Ingrese cantidad positiva';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
