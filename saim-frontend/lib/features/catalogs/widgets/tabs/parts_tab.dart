import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/saim_button.dart';
import '../table_helpers.dart';
import '../../../../core/theme/app_theme.dart';

class PartsTab extends StatelessWidget {
  PartsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: CatalogPanel(
            title: 'Refacciones homologadas',
            subtitle: 'Stock, mínimo, reorden y precio demo',
            trailing: SaimButton(
              text: 'Abrir backlog',
              type: SaimButtonType.secondary,
              small: true,
              onPressed: () {},
            ),
            child: CatalogDataTable(
              columns: ['REFACCIÓN', 'UNIDAD', 'STOCK', 'MÍNIMO', 'REORDEN', 'PRECIO', 'ESTADO'],
              rows: [
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Compresor 5HP', 'REF-01 · Compresores'),
                  DataCell(Text('Pieza')),
                  DataCell(Text('2')),
                  DataCell(Text('3')),
                  DataCell(Text('5')),
                  DataCell(Text('\$12,500.00')),
                  DataCell(StatusPill(text: 'Reorden', type: StatusType.danger)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Filtro deshidratador', 'REF-02 · Filtros'),
                  DataCell(Text('Pieza')),
                  DataCell(Text('15')),
                  DataCell(Text('10')),
                  DataCell(Text('20')),
                  DataCell(Text('\$450.00')),
                  DataCell(StatusPill(text: 'Disponible', type: StatusType.success)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Gas R-404A', 'REF-03 · Refrigerantes'),
                  DataCell(Text('Cilindro')),
                  DataCell(Text('4')),
                  DataCell(Text('5')),
                  DataCell(Text('10')),
                  DataCell(Text('\$3,200.00')),
                  DataCell(StatusPill(text: 'Reorden', type: StatusType.danger)),
                ]),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              CatalogPanel(
                title: 'Materiales',
                subtitle: 'Consumos de la orden',
                child: CatalogDataTable(
                  columns: ['MATERIAL', 'UNIDAD', 'STOCK'],
                  rows: [
                    DataRow(cells: [
                      _titleSubtitleCell(context, 'Cinta aislante', 'MAT-01'),
                      DataCell(Text('Pieza')),
                      DataCell(Text('50')),
                    ]),
                    DataRow(cells: [
                      _titleSubtitleCell(context, 'Tubo cobre 3/8"', 'MAT-02'),
                      DataCell(Text('Metro')),
                      DataCell(Text('120')),
                    ]),
                  ],
                ),
              ),
              SizedBox(height: 24),
              CatalogPanel(
                title: 'Proveedores',
                subtitle: 'Fuentes de suministro',
                child: CatalogDataTable(
                  columns: ['PROVEEDOR', 'TIPO', 'ENTREGA', 'ESTADO'],
                  rows: [
                    DataRow(cells: [
                      _titleSubtitleCell(context, 'Refrigeración S.A.', 'PRV-01'),
                      DataCell(Text('Refacciones')),
                      DataCell(Text('1-2 días')),
                      DataCell(StatusPill(text: 'Activo', type: StatusType.success)),
                    ]),
                    DataRow(cells: [
                      _titleSubtitleCell(context, 'Gases Nacionales', 'PRV-02'),
                      DataCell(Text('Refrigerantes')),
                      DataCell(Text('Mismo día')),
                      DataCell(StatusPill(text: 'Activo', type: StatusType.success)),
                    ]),
                  ],
                ),
              ),
            ],
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
