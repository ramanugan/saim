import 'package:flutter/material.dart';
import '../panels/active_conditions_panel.dart';
import '../panels/technical_families_panel.dart';
import '../panels/recent_activity_panel.dart';

class SummaryTab extends StatelessWidget {
  SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Active Conditions + Technical Families)
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ActiveConditionsPanel(),
              SizedBox(height: 24),
              TechnicalFamiliesPanel(),
            ],
          ),
        ),
        SizedBox(width: 24),
        
        // Right Column (Recent Activity timeline spans 2 columns in CSS but flex handles it)
        Expanded(
          flex: 2,
          child: RecentActivityPanel(),
        ),
      ],
    );
  }
}
