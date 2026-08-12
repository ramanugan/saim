import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class MovimientosRecientesTable extends StatelessWidget {
  MovimientosRecientesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Movimientos recientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                      SizedBox(height: 4),
                      Text('Todo gasto debe quedar aplicado y comprobado', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildDropdown(context, 'Todas las categorías'),
                    SizedBox(width: 8),
                    _buildDropdown(context, 'Todos los estados'),
                  ],
                )
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Color(0xFFF8FAFC)),
                    headingTextStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: context.mutedTextColor,
                    ),
                    dataTextStyle: TextStyle(fontSize: 13, color: context.textColor),
                    columns: [
                      DataColumn(label: SizedBox(width: 60, child: Text('FECHA', softWrap: false))),
                      DataColumn(label: SizedBox(width: 120, child: Text('EMPLEADO', softWrap: false))),
                      DataColumn(label: SizedBox(width: 100, child: Text('CATEGORÍA', softWrap: false))),
                      DataColumn(label: SizedBox(width: 180, child: Text('SERVICIO / RUTA', softWrap: false))),
                      DataColumn(label: SizedBox(width: 80, child: Text('IMPORTE', softWrap: false))),
                      DataColumn(label: SizedBox(width: 120, child: Text('COMPROBANTE', softWrap: false))),
                      DataColumn(label: SizedBox(width: 100, child: Text('ESTADO', softWrap: false))),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      _buildRow(context, '21 jul', 'José Ramírez', 'Combustible', 'Ruta GDL-02 · 3 órdenes', '\$2,184', 'CFDI validado', 'En revisión', StatusType.info),
                      _buildRow(context, '20 jul', 'Óscar Salgado', 'Viáticos', 'IG-00086 · Pachuca', '\$1,260', '8 de 8', 'Aprobado', StatusType.success),
                      _buildRow(context, '19 jul', 'Elena Pérez', 'Anticipo', 'Ruta NAY-01', '\$5,000', 'Faltan \$1,420', 'Vencido', StatusType.danger),
                      _buildRow(context, '18 jul', 'Arturo Gómez', 'Herramienta', 'COR-2026-00204', '\$0', 'Custodia HT-00418', 'Por devolver', StatusType.warning),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String value) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, size: 16, color: context.mutedTextColor),
          style: TextStyle(fontSize: 12, color: context.textColor),
          items: [DropdownMenuItem(value: value, child: Text(value))],
          onChanged: (v) {},
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, String fecha, String emp, String cat, String serv, String imp, String comp, String status, StatusType type) {
    return DataRow(
      cells: [
        DataCell(SizedBox(width: 60, child: Text(fecha, softWrap: false, overflow: TextOverflow.ellipsis))),
        DataCell(SizedBox(width: 120, child: Text(emp, softWrap: false, overflow: TextOverflow.ellipsis))),
        DataCell(SizedBox(width: 100, child: Text(cat, softWrap: false, overflow: TextOverflow.ellipsis))),
        DataCell(SizedBox(width: 180, child: Text(serv, softWrap: false, overflow: TextOverflow.ellipsis))),
        DataCell(SizedBox(width: 80, child: Text(imp, style: TextStyle(fontWeight: FontWeight.bold), softWrap: false, overflow: TextOverflow.ellipsis))),
        DataCell(SizedBox(width: 120, child: Text(comp, style: TextStyle(color: context.mutedTextColor), softWrap: false, overflow: TextOverflow.ellipsis))),
        DataCell(StatusPill(text: status, type: type)),
        DataCell(
          TextButton(
            onPressed: () {
              _showDialog(context, 'Abrir movimiento');
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
            child: Text('Abrir', style: TextStyle(color: AppColors.blue, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('En construcción'),
        content: Text('Acción: \$action'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cerrar')),
        ],
      ),
    );
  }
}
