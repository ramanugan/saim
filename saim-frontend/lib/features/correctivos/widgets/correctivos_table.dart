import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class CorrectivosTable extends StatelessWidget {
  CorrectivosTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
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
                    Text(
                      'Seguimiento de correctivos',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Estados operativo, comercial y financiero separados',
                      style: TextStyle(
                        color: context.mutedTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildFilterDropdown(context, 'Todos los estados'),
                    SizedBox(width: 8),
                    _buildSearchBox(context, ),
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dataTableTheme: DataTableThemeData(
                        dataTextStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.ink,
                        ),
                        headingTextStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.mutedTextColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    child: DataTable(
                headingRowColor: WidgetStateProperty.all(Color(0xFFF3F6FA)),
                headingRowHeight: 40,
                dataRowMinHeight: 48,
                dataRowMaxHeight: 64,
                dividerThickness: 1,
                horizontalMargin: 16,
                columnSpacing: 16,
                border: TableBorder(
                  horizontalInside: BorderSide(color: context.borderColor, width: 1),
                ),
                columns: [
                  DataColumn(label: Text('FOLIO / TIENDA')),
                  DataColumn(label: Text('FALLA')),
                  DataColumn(label: Text('SOLICITÓ')),
                  DataColumn(label: Text('OPERATIVO')),
                  DataColumn(label: Text('COMERCIAL')),
                  DataColumn(label: Text('FINANCIERO')),
                  DataColumn(label: Text('MONTO')),
                  DataColumn(label: Text('ANTIGÜEDAD')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  _buildRow(context, 
                    id: 'COR-2026-00208',
                    store: 'Satélite · IG-00078',
                    falla: 'Pérdida de temperatura',
                    solicito: 'Ana Torres',
                    solicitoDate: '26 jul 07:42',
                    statusOp: StatusType.info,
                    statusOpText: 'En diagnóstico',
                    statusCom: StatusType.warning,
                    statusComText: 'Pend. cotización',
                    statusFin: StatusType.neutral,
                    statusFinText: '—',
                    monto: 'Por definir',
                    antiguedad: '5 h',
                  ),
                  _buildRow(context, 
                    id: 'COR-2026-00204',
                    store: 'Bugambilias · IG-00014',
                    falla: 'Fuga de refrigerante',
                    solicito: 'Mario Ruiz',
                    solicitoDate: '18 jul 12:14',
                    statusOp: StatusType.success,
                    statusOpText: 'Aceptado',
                    statusCom: StatusType.warning,
                    statusComText: 'Pend. pedido',
                    statusFin: StatusType.neutral,
                    statusFinText: 'No facturado',
                    monto: '\$82,400',
                    antiguedad: '8 días',
                  ),
                  _buildRow(context, 
                    id: 'COR-2026-00198',
                    store: 'Río Nilo · IG-00028',
                    falla: 'Contactor con desgaste',
                    solicito: 'Hallazgo preventivo',
                    solicitoDate: '15 jul 12:00',
                    statusOp: StatusType.info,
                    statusOpText: 'Programado',
                    statusCom: StatusType.success,
                    statusComText: 'Autorizado',
                    statusFin: StatusType.neutral,
                    statusFinText: 'No facturado',
                    monto: '\$13,800',
                    antiguedad: '11 días',
                  ),
                  _buildRow(context, 
                    id: 'COR-2026-00102',
                    store: 'Río Nilo · IG-00028',
                    falla: 'Fuga de refrigerante',
                    solicito: 'Carlos H.',
                    solicitoDate: '02 jul 09:10',
                    statusOp: StatusType.success,
                    statusOpText: 'Aceptado',
                    statusCom: StatusType.success,
                    statusComText: 'Facturado',
                    statusFin: StatusType.success,
                    statusFinText: 'Pagado',
                    monto: '\$28,640',
                    antiguedad: '24 días',
                  ),
                ],
              ),
            ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Text(text, style: TextStyle(fontSize: 12)),
          SizedBox(width: 8),
          Icon(Icons.arrow_drop_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      width: 150,
      child: Row(
        children: [
          Icon(Icons.search, size: 14, color: context.mutedTextColor),
          SizedBox(width: 8),
          Text('Folio, tienda o falla', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, {
    required String id,
    required String store,
    required String falla,
    required String solicito,
    required String solicitoDate,
    required StatusType statusOp,
    required String statusOpText,
    required StatusType statusCom,
    required String statusComText,
    required StatusType statusFin,
    required String statusFinText,
    required String monto,
    required String antiguedad,
  }) {
    return DataRow(
      cells: [
        DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(id, style: TextStyle(fontWeight: FontWeight.bold)), Text(store, style: TextStyle(color: context.mutedTextColor, fontSize: 10))])),
        DataCell(Text(falla, style: TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(solicito), Text(solicitoDate, style: TextStyle(color: context.mutedTextColor, fontSize: 10))])),
        DataCell(StatusPill(text: statusOpText, type: statusOp)),
        DataCell(StatusPill(text: statusComText, type: statusCom)),
        DataCell(StatusPill(text: statusFinText, type: statusFin)),
        DataCell(Text(monto)),
        DataCell(Text(antiguedad)),
        DataCell(
          TextButton(
            onPressed: () {},
            child: Text('Abrir', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
