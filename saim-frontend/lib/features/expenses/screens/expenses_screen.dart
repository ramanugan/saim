import 'package:flutter/material.dart';
import '../../../shared/layouts/app_layout.dart';
import '../../../shared/widgets/page_heading.dart';
import '../../../shared/widgets/saim_button.dart';
import '../widgets/gastos_summary.dart';
import '../widgets/movimientos_recientes_table.dart';
import '../widgets/anticipos_pendientes_list.dart';
import '../widgets/control_combustible_panel.dart';
import '../widgets/custodia_herramientas_list.dart';

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Gastos y recursos',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageHeading(
                eyebrow: 'Control estricto de costos',
                title: 'Gastos, anticipos y recursos',
                subtitle: 'Solicitud, autorización, ejercicio, comprobación y aplicación al servicio.',
                actions: Row(
                  children: [
                    SaimButton(
                      text: 'Ver políticas',
                      onPressed: () => _showDialog(context, 'Ver políticas'),
                      type: SaimButtonType.secondary,
                    ),
                    SizedBox(width: 12),
                    SaimButton(
                      text: '＋ Registrar gasto',
                      onPressed: () => _showDialog(context, 'Registrar gasto'),
                      type: SaimButtonType.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              GastosSummary(),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        MovimientosRecientesTable(),
                        SizedBox(height: 24),
                        ControlCombustiblePanel(),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        AnticiposPendientesList(),
                        SizedBox(height: 24),
                        CustodiaHerramientasList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
