import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import '../../shared/widgets/page_heading.dart';
import '../../shared/widgets/saim_button.dart';
import 'widgets/parts_context_strip.dart';
import 'widgets/parts_kpi_grid.dart';
import 'widgets/parts_backlog_table.dart';
import 'widgets/part_detail_panel.dart';
import 'widgets/opportunity_card.dart';

class PartsBacklogScreen extends StatelessWidget {
  PartsBacklogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Refacciones y backlog',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeading(
              eyebrow: 'Continuidad operativa',
              title: 'Refacciones y backlog',
              subtitle: 'Seguimiento de necesidad, solicitud, autorización, suministro e instalación.',
              actions: Row(
                children: [
                  SaimButton(
                    text: '⇧ Importar catálogo',
                    onPressed: () {},
                    type: SaimButtonType.secondary,
                  ),
                  SizedBox(width: 12),
                  SaimButton(
                    text: '＋ Nueva solicitud',
                    onPressed: () {},
                    type: SaimButtonType.primary,
                  ),
                ],
              ),
            ),
            PartsContextStrip(
              title: 'Malecón · IG-00030',
              subtitle: 'COR-2026-00201 · OS-2026-00518 · Unidad condensadora 03',
            ),
            PartsKpiGrid(),
            PartsBacklogTable(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: PartDetailPanel()),
                SizedBox(width: 24),
                Expanded(child: OpportunityCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
