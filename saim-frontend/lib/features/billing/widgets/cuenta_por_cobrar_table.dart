import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class CuentaPorCobrarTable extends StatelessWidget {
  CuentaPorCobrarTable({super.key});

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cuenta por cobrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                    SizedBox(height: 4),
                    Text('Saldo calculado desde facturas, pagos y notas', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        border: Border.all(color: context.borderColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text('Todas las antigüedades', style: TextStyle(fontSize: 12, color: context.textColor)),
                          SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: context.mutedTextColor),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        border: Border.all(color: context.borderColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 16, color: context.mutedTextColor),
                          SizedBox(width: 8),
                          Text('Factura o proyecto', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    headingRowColor: WidgetStateProperty.all(context.backgroundColor),
                    columnSpacing: 24,
                    dataRowMaxHeight: 64,
                    columns: [
                      DataColumn(label: Text('FACTURA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('CORRECTIVO / TIENDA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('EMISIÓN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('VENCIMIENTO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('TOTAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('PAGADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('SALDO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('ANTIGÜEDAD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('ESTADO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.mutedTextColor))),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      _buildRow(
                        context,
                        'F-1848', 'UUID …8a21',
                        'COR-2026-00184', 'Satélite',
                        '01 jun', '01 jul',
                        '\$131,100', '\$0', '\$131,100',
                        '20 días',
                        'Vencida', StatusType.danger,
                        'Cobrar',
                      ),
                      _buildRow(
                        context,
                        'F-1862', 'UUID …c418',
                        'COR-2026-00192', 'Río Nilo',
                        '05 jul', '04 ago',
                        '\$28,640', '\$28,640', '\$0',
                        '—',
                        'Pagada', StatusType.success,
                        'Ver',
                      ),
                      _buildRow(
                        context,
                        'F-1868', 'UUID …f302',
                        'COR-2026-00196', 'Cordilleras',
                        '12 jul', '11 ago',
                        '\$74,800', '\$25,000', '\$49,800',
                        'Por vencer',
                        'Pago parcial', StatusType.warning,
                        'Aplicar pago',
                      ),
                      _buildRow(
                        context,
                        'F-1871', 'UUID …bb18',
                        'COR-2026-00201', 'Malecón',
                        '17 jul', '16 ago',
                        '\$98,400', '\$0', '\$98,400',
                        'Por vencer',
                        'Por cobrar', StatusType.info,
                        'Ver',
                      ),
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

  DataRow _buildRow(
    BuildContext context,
    String invId, String invSub,
    String corrId, String corrSub,
    String emission, String dueDate,
    String total, String paid, String balance,
    String aging,
    String statusLabel, StatusType statusType,
    String btnText,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(invId, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.textColor)),
              Text(invSub, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
            ],
          ),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(corrId, style: TextStyle(fontSize: 13, color: context.textColor)),
              Text(corrSub, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
            ],
          ),
        ),
        DataCell(Text(emission, style: TextStyle(fontSize: 13, color: context.textColor))),
        DataCell(Text(dueDate, style: TextStyle(fontSize: 13, color: context.textColor))),
        DataCell(Text(total, style: TextStyle(fontSize: 13, color: context.textColor))),
        DataCell(Text(paid, style: TextStyle(fontSize: 13, color: context.textColor))),
        DataCell(Text(balance, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textColor))),
        DataCell(Text(aging, style: TextStyle(fontSize: 13, color: context.textColor))),
        DataCell(StatusPill(text: statusLabel, type: statusType)),
        DataCell(
          TextButton(
            onPressed: () {
              _showDialog(context, btnText);
            },
            child: Text(btnText, style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
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
