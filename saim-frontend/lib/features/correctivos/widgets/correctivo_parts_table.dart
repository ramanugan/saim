import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class CorrectivoPartsTable extends StatelessWidget {
  CorrectivoPartsTable({super.key});

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
                      'Refacciones del correctivo COR-2026-00208',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Se originan dentro del expediente correctivo y permanecen vinculadas a IG-00078 y a sus órdenes.',
                      style: TextStyle(
                        color: context.mutedTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Abrir seguimiento completo', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold)),
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
                  DataColumn(label: Text('SOLICITUD')),
                  DataColumn(label: Text('ORDEN')),
                  DataColumn(label: Text('EQUIPO')),
                  DataColumn(label: Text('REFACCIÓN')),
                  DataColumn(label: Text('NECESARIA')),
                  DataColumn(label: Text('SUMINISTRADA')),
                  DataColumn(label: Text('ESTADO')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  _buildRow(context, 
                    id: 'SRF-2026-00294',
                    store: 'IG-00078',
                    orden: 'OS-2026-00550',
                    equipo: 'Rack de refrigeración 02',
                    refaccion: 'Sensor de temperatura NTC',
                    nec: '6',
                    sum: '4',
                    status: StatusType.danger,
                    statusText: 'Crítica',
                  ),
                  _buildRow(context, 
                    id: 'SRF-2026-00328',
                    store: 'IG-00078',
                    orden: 'Diagnóstico',
                    equipo: 'Rack de refrigeración 02',
                    refaccion: 'Válvula de expansión 5/8',
                    nec: '1',
                    sum: '0',
                    status: StatusType.warning,
                    statusText: 'Por cotizar',
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

  DataRow _buildRow(BuildContext context, {
    required String id,
    required String store,
    required String orden,
    required String equipo,
    required String refaccion,
    required String nec,
    required String sum,
    required StatusType status,
    required String statusText,
  }) {
    return DataRow(
      cells: [
        DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(id, style: TextStyle(fontWeight: FontWeight.bold)), Text(store, style: TextStyle(color: context.mutedTextColor, fontSize: 10))])),
        DataCell(Text(orden)),
        DataCell(Text(equipo)),
        DataCell(Text(refaccion, style: TextStyle(fontWeight: FontWeight.w600))),
        DataCell(Text(nec)),
        DataCell(Text(sum)),
        DataCell(StatusPill(text: statusText, type: status)),
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
