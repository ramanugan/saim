import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_filter_strip.dart';
import 'widgets/kpi_grid.dart';
import 'widgets/bar_chart_card.dart';
import 'widgets/donut_chart_card.dart';
import 'widgets/priority_services_table.dart';
import 'widgets/funnel_chart_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Tablero',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            DashboardFilterStrip(),
            KpiGrid(),
            
            // Charts Area
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;
                
                if (isDesktop) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: BarChartCard()),
                          SizedBox(width: 24),
                          Expanded(flex: 1, child: DonutChartCard()),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: PriorityServicesTable()),
                          SizedBox(width: 24),
                          Expanded(flex: 1, child: FunnelChartCard()),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      BarChartCard(),
                      SizedBox(height: 24),
                      DonutChartCard(),
                      SizedBox(height: 24),
                      PriorityServicesTable(),
                      SizedBox(height: 24),
                      FunnelChartCard(),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 48), // Bottom padding
          ],
        ),
      ),
    );
  }
}
