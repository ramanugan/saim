import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import '../../shared/widgets/page_heading.dart';
import '../../shared/widgets/saim_button.dart';
import '../../shared/widgets/stage_strip.dart';
import 'widgets/correctivos_table.dart';
import 'widgets/correctivo_detail_panel.dart';
import 'widgets/correctivo_parts_table.dart';

class CorrectivosScreen extends StatelessWidget {
  CorrectivosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Mantenimientos correctivos',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeading(
              eyebrow: 'Fallas no previstas · cobro adicional',
              title: 'Mantenimientos correctivos',
              subtitle: 'Solicitud, diagnóstico, cotización, autorización, ejecución, pedido, factura y pago.',
              actions: Row(
                children: [
                  SaimButton(
                    text: '⇩ Reporte',
                    onPressed: () {},
                    type: SaimButtonType.secondary,
                  ),
                  SizedBox(width: 12),
                  SaimButton(
                    text: '＋ Registrar falla',
                    onPressed: () {},
                    type: SaimButtonType.primary,
                  ),
                ],
              ),
            ),
            StageStrip(
              items: [
                StageItem(label: 'Reportados', value: '24', subtitle: '\$1.24 M'),
                StageItem(label: 'Cotizados', value: '18', subtitle: '\$980 mil'),
                StageItem(label: 'Autorizados', value: '11', subtitle: '\$712 mil'),
                StageItem(label: 'En ejecución', value: '6', subtitle: '\$430 mil'),
                StageItem(label: 'Por facturar', value: '4', subtitle: '\$286 mil'),
                StageItem(label: 'Cobrados', value: '8', subtitle: '\$305 mil'),
              ],
            ),
            CorrectivosTable(),
            CorrectivoDetailPanel(),
            CorrectivoPartsTable(),
          ],
        ),
      ),
    );
  }
}
