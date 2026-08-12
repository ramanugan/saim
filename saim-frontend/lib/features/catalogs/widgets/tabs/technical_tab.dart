import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../table_helpers.dart';
import '../../../../core/theme/app_theme.dart';

class TechnicalTab extends StatelessWidget {
  TechnicalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: CatalogPanel(
            title: 'Equipos',
            subtitle: 'Instalados por tienda',
            child: CatalogDataTable(
              columns: ['EQUIPO', 'TIENDA / IGUALA', 'MODELO / SERIE', 'UBICACIÓN', 'ESTADO'],
              rows: [
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Condensadora A', 'EQ-001'),
                  _titleSubtitleCell(context, 'Río Nilo', 'IG-00028'),
                  DataCell(Text('Carrier X / SN-123')),
                  DataCell(Text('Azotea')),
                  DataCell(StatusPill(text: 'Operación parcial', type: StatusType.warning)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Evaporadora 1', 'EQ-002'),
                  _titleSubtitleCell(context, 'Río Nilo', 'IG-00028'),
                  DataCell(Text('Bohn / SN-456')),
                  DataCell(Text('Piso de ventas')),
                  DataCell(StatusPill(text: 'Crítico', type: StatusType.danger)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Vitrina Lácteos', 'EQ-003'),
                  _titleSubtitleCell(context, 'Bugambilias', 'IG-00016'),
                  DataCell(Text('Hussmann / SN-789')),
                  DataCell(Text('Pasillo 3')),
                  DataCell(StatusPill(text: 'Operativo', type: StatusType.success)),
                ]),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: CatalogPanel(
            title: 'Tipos de medición',
            subtitle: 'Campos configurables de la orden',
            child: CatalogDataTable(
              columns: ['CÓDIGO', 'MEDICIÓN', 'UNIDAD'],
              rows: [
                DataRow(cells: [
                  DataCell(Text('TMP')),
                  DataCell(Text('Temperatura', style: TextStyle(fontWeight: FontWeight.w700))),
                  DataCell(Text('°C')),
                ]),
                DataRow(cells: [
                  DataCell(Text('PRS')),
                  DataCell(Text('Presión', style: TextStyle(fontWeight: FontWeight.w700))),
                  DataCell(Text('PSI')),
                ]),
                DataRow(cells: [
                  DataCell(Text('VOL')),
                  DataCell(Text('Voltaje', style: TextStyle(fontWeight: FontWeight.w700))),
                  DataCell(Text('V')),
                ]),
                DataRow(cells: [
                  DataCell(Text('AMP')),
                  DataCell(Text('Amperaje', style: TextStyle(fontWeight: FontWeight.w700))),
                  DataCell(Text('A')),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DataCell _titleSubtitleCell(BuildContext context, String title, String subtitle) {
    return DataCell(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w700, color: context.textColor),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: context.mutedTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
