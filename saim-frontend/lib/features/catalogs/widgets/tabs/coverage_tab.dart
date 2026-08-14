import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../table_helpers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/auth_provider.dart';
import '../modals/crud_clientes_modal.dart';
import '../modals/crud_contratos_modal.dart';
import '../modals/crud_zonas_estado_modal.dart';
import '../modals/crud_estados_modal.dart';

class CoverageTab extends ConsumerWidget {
  CoverageTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(currentUserProfileProvider).value?.role?.name == 'Administrador';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CatalogPanel(
            title: 'Cliente y contratos',
            subtitle: 'Escenario contractual',
            trailing: isAdmin ? Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(context: context, builder: (ctx) => CrudClientesModal());
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.red),
                  child: Text('Clientes +'),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    showDialog(context: context, builder: (ctx) => CrudContratosModal());
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.red),
                  child: Text('Contratos +'),
                ),
              ],
            ) : null,
            child: CatalogDataTable(
              columns: ['CONTRATO', 'VIGENCIA', 'ZONAS', 'TIENDAS', 'ESTADO'],
              rows: [
                DataRow(cells: [
                  _titleSubtitleCell(context, 'MN-SOR-2026-01', 'Mantenimiento nacional 2026'),
                  DataCell(Text('2026-01-01 – 2026-12-31')),
                  DataCell(Text('4')),
                  DataCell(Text('184')),
                  DataCell(StatusPill(text: 'Vigente', type: StatusType.success)),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'MN-SOR-2025-01', 'Mantenimiento nacional 2025'),
                  DataCell(Text('2025-01-01 – 2025-12-31')),
                  DataCell(Text('4')),
                  DataCell(Text('176')),
                  DataCell(StatusPill(text: 'Cerrado', type: StatusType.neutral)),
                ]),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: CatalogPanel(
            title: 'Zonas y estados',
            subtitle: 'Alcance territorial del contrato',
            trailing: isAdmin ? Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(context: context, builder: (ctx) => CrudZonasEstadoModal());
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.red),
                  child: Text('Zonas +'),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    showDialog(context: context, builder: (ctx) => CrudEstadosModal());
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.red),
                  child: Text('Estados +'),
                ),
              ],
            ) : null,
            child: CatalogDataTable(
              columns: ['ZONA', 'COORDINACIÓN', 'ESTADOS', 'TIENDAS', ''],
              rows: [
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Occidente', 'ZON-OCC'),
                  DataCell(Text('Adriana\nMéndez')),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Jalisco, Nayarit, Colima, Michoacán, Aguascalientes'),
                  )),
                  DataCell(Text('52')),
                  _actionCell(),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Norte', 'ZON-NOR'),
                  DataCell(Text('Roberto Núñez')),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Nuevo León, Coahuila, Tamaulipas, Chihuahua, Sonora, Durango, Sinaloa, Baja California'),
                  )),
                  DataCell(Text('61')),
                  _actionCell(),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Centro', 'ZON-CEN'),
                  DataCell(Text('Jorge Soto')),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Ciudad de México, Estado de México, Hidalgo, Puebla, Querétaro, Morelos, Tlaxcala'),
                  )),
                  DataCell(Text('48')),
                  _actionCell(),
                ]),
                DataRow(cells: [
                  _titleSubtitleCell(context, 'Sureste', 'ZON-SUR'),
                  DataCell(Text('Laura Paredes')),
                  DataCell(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Veracruz, Tabasco, Campeche, Yucatán, Quintana Roo, Chiapas'),
                  )),
                  DataCell(Text('23')),
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
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          padding: EdgeInsets.zero,
          minimumSize: Size(60, 36),
        ),
        child: Text('Abrir'),
      ),
    );
  }
}
