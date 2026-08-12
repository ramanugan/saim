import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/coverage_header.dart';
import 'widgets/coverage_summary_banner.dart';
import 'widgets/contract_tree_panel.dart';
import 'widgets/store_detail_panel.dart';

class ContractCoverageScreen extends StatelessWidget {
  ContractCoverageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Contrato y cobertura',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CoverageHeader(),
            CoverageSummaryBanner(),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: ContractTreePanel()),
                      SizedBox(width: 24),
                      Expanded(flex: 3, child: StoreDetailPanel()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ContractTreePanel(),
                      SizedBox(height: 24),
                      StoreDetailPanel(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
