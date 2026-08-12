import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../table_helpers.dart';
import '../../../../core/theme/app_theme.dart';

class PeopleTab extends StatelessWidget {
  PeopleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CatalogPanel(
            title: 'Técnicos',
            subtitle: 'Especialidad, base y disponibilidad',
            child: CatalogDataTable(
              columns: ['NOMBRE', 'ROL', 'ESPECIALIDAD', 'BASE', 'ESTADO'],
              rows: [
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Juan Pérez', 'TEC-01'),
                  DataCell(Text('Técnico')),
                  DataCell(Text('Refrigeración')),
                  DataCell(Text('Guadalajara')),
                  DataCell(StatusPill(text: 'En ejecución', type: StatusType.info)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'María López', 'TEC-02'),
                  DataCell(Text('Líder')),
                  DataCell(Text('Refrigeración')),
                  DataCell(Text('Zapopan')),
                  DataCell(StatusPill(text: 'Disponible', type: StatusType.success)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Carlos Ruiz', 'TEC-03'),
                  DataCell(Text('Técnico')),
                  DataCell(Text('A/A')),
                  DataCell(Text('Tlaquepaque')),
                  DataCell(StatusPill(text: 'Incapacidad', type: StatusType.warning)),
                ]),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: CatalogPanel(
            title: 'Cuadrillas',
            subtitle: 'Integración y asignación vigente',
            child: CatalogDataTable(
              columns: ['CUADRILLA', 'INTEGRANTES', 'SERVICIO', 'ESTADO', ''],
              rows: [
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Cuadrilla Alfa', 'CUA-01'),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('María López / Juan Pérez'),
                  )),
                  DataCell(Text('OS-2026-00536')),
                  DataCell(StatusPill(text: 'Asignada', type: StatusType.info)),
                  _actionCell(),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Cuadrilla Beta', 'CUA-02'),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Carlos Ruiz / Ana Torres'),
                  )),
                  DataCell(Text('—')),
                  DataCell(StatusPill(text: 'Disponible', type: StatusType.info)),
                  _actionCell(),
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
