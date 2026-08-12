import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class PartsBacklogTable extends StatelessWidget {
  PartsBacklogTable({super.key});

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
                      'Backlog abierto',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'La brecha se calcula desde los movimientos; no se captura manualmente.',
                      style: TextStyle(
                        color: context.mutedTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildFilterDropdown(context, 'Todas las criticidades'),
                    SizedBox(width: 8),
                    _buildFilterDropdown(context, 'Todas las zonas'),
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
                dataRowMaxHeight: 64, // Keep slightly larger for two lines of text
                dividerThickness: 1,
                horizontalMargin: 16,
                columnSpacing: 16,
                border: TableBorder(
                  horizontalInside: BorderSide(color: context.borderColor, width: 1),
                ),
              columns: [
                DataColumn(label: Text('SOLICITUD / TIENDA')),
                DataColumn(label: Text('ORIGEN VINCULADO')),
                DataColumn(label: Text('REFACCIÓN')),
                DataColumn(label: Text('NECESARIA')),
                DataColumn(label: Text('SOLICITADA')),
                DataColumn(label: Text('AUTORIZADA')),
                DataColumn(label: Text('SUMINISTRADA')),
                DataColumn(label: Text('INSTALADA')),
                DataColumn(label: Text('BRECHA')),
                DataColumn(label: Text('ANTIGÜEDAD')),
                DataColumn(label: Text('ESTADO')),
                DataColumn(label: Text('VÍNCULOS')),
              ],
              rows: [
                _buildRow(context, 
                  id: 'SRF-2026-00318',
                  store: 'Malecón · IG-00030',
                  origin: 'Correctivo',
                  originId: 'COR-2026-00201',
                  part: 'Contactor 40 A · 3 polos',
                  partDesc: 'Unidad condensadora 03',
                  nec: '4', sol: '4', aut: '4', sum: '2', inst: '2', brecha: '2',
                  antiguedad: '12 días',
                  status: StatusType.danger,
                  statusText: 'Crítica',
                ),
                _buildRow(context, 
                  id: 'SRF-2026-00312',
                  store: 'Río Nilo · IG-00028',
                  origin: 'Hallazgo preventivo',
                  originId: 'OS-2026-00534 · UMA planta baja',
                  part: 'Contactor 40 A · 3 polos',
                  partDesc: 'Panel de control',
                  nec: '2', sol: '1', aut: '2', sum: '2', inst: '0', brecha: '1',
                  antiguedad: '6 días',
                  status: StatusType.warning,
                  statusText: 'Autorizada',
                ),
                _buildRow(context, 
                  id: 'SRF-2026-00309',
                  store: 'Pachuca · IG-00086',
                  origin: 'Orden preventiva',
                  originId: 'OS-2026-00536',
                  part: 'Refrigerante R-22 · cilindro',
                  partDesc: 'Fuga en purga de gas',
                  nec: '2', sol: '2', aut: '1', sum: '1', inst: '1', brecha: '1',
                  antiguedad: '5 días',
                  status: StatusType.info,
                  statusText: 'Parcial',
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
          Text('Buscar refacción', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, {
    required String id,
    required String store,
    required String origin,
    required String originId,
    required String part,
    required String partDesc,
    required String nec,
    required String sol,
    required String aut,
    required String sum,
    required String inst,
    required String brecha,
    required String antiguedad,
    required StatusType status,
    required String statusText,
  }) {
    return DataRow(
      cells: [
        DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(id, style: TextStyle(fontWeight: FontWeight.bold)), Text(store, style: TextStyle(color: context.mutedTextColor, fontSize: 10))])),
        DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(origin, style: TextStyle(fontWeight: FontWeight.bold)), Text(originId, style: TextStyle(color: context.mutedTextColor, fontSize: 10))])),
        DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(part, style: TextStyle(fontWeight: FontWeight.bold)), Text(partDesc, style: TextStyle(color: context.mutedTextColor, fontSize: 10))])),
        DataCell(Text(nec)),
        DataCell(Text(sol)),
        DataCell(Text(aut)),
        DataCell(Text(sum)),
        DataCell(Text(inst)),
        DataCell(Text(brecha, style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold))),
        DataCell(Text(antiguedad, style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(StatusPill(text: statusText, type: status)),
        DataCell(Row(
          children: [
            _buildSmallChip(context, 'Detalle'),
            SizedBox(width: 4),
            _buildSmallChip(context, 'Iguala'),
            SizedBox(width: 4),
            _buildSmallChip(context, 'Orden'),
            SizedBox(width: 4),
            _buildSmallChip(context, 'Correctivo'),
          ],
        )),
      ],
    );
  }

  Widget _buildSmallChip(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Color(0xFFB8C8D8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
