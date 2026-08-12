import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../table_helpers.dart';
import '../../../../core/theme/app_theme.dart';

class StoresTab extends StatelessWidget {
  StoresTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPanel(
      title: 'Tiendas e igualas',
      subtitle: 'Cada iguala cubre una sola tienda.',
      trailing: StatusPill(text: '4 registros demo', type: StatusType.info),
      child: CatalogDataTable(
        columns: ['TIENDA', 'TIPO', 'ZONA', 'UBICACIÓN', 'IGUALA', 'CUOTA', ''],
        rows: [
          DataRow(cells: [
            _titleSubtitleCell(context, 'Río Nilo', 'Det. 28 · ID-RN'),
            DataCell(Text('Súper')),
            DataCell(Text('Occidente')),
            DataCell(Text('Jalisco / Guadalajara')),
            _titleSubtitleCell(context, 'IG-00028', 'Bimestral · 6 h'),
            DataCell(Text('\$18,500.00')),
            _actionCell(),
          ]),
          DataRow(cells: [
            _titleSubtitleCell(context, 'Bugambilias', 'Det. 16 · ID-BG'),
            DataCell(Text('Híper')),
            DataCell(Text('Occidente')),
            DataCell(Text('Jalisco / Zapopan')),
            _titleSubtitleCell(context, 'IG-00016', 'Bimestral · 8 h'),
            DataCell(Text('\$22,000.00')),
            _actionCell(),
          ]),
          DataRow(cells: [
            _titleSubtitleCell(context, 'Malecón', 'Det. 30 · ID-ML'),
            DataCell(Text('City Club')),
            DataCell(Text('Occidente')),
            DataCell(Text('Jalisco / Tonalá')),
            _titleSubtitleCell(context, 'IG-00030', 'Trimestral · 12 h'),
            DataCell(Text('\$30,000.00')),
            _actionCell(),
          ]),
          DataRow(cells: [
            _titleSubtitleCell(context, 'Cordilleras', 'Det. 61 · ID-CD'),
            DataCell(Text('Mercado')),
            DataCell(Text('Occidente')),
            DataCell(Text('Jalisco / Zapopan')),
            _titleSubtitleCell(context, 'IG-00061', 'Mensual · 4 h'),
            DataCell(Text('\$12,000.00')),
            _actionCell(),
          ]),
        ],
      ),
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

  DataCell _actionCell() {
    return DataCell(
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: AppColors.blue,
          padding: EdgeInsets.symmetric(horizontal: 12),
          minimumSize: Size.zero,
        ),
        child: Text('Abrir', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
