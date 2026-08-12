import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CoverageSummaryBanner extends StatelessWidget {
  CoverageSummaryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: context.textColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.textColor.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _SummaryItem(label: 'CLIENTE', value: 'Soriana')),
          SizedBox(width: 15),
          Expanded(child: _SummaryItem(label: 'CONTRATO', value: 'Mantenimiento nacional 2026')),
          SizedBox(width: 15),
          Expanded(child: _SummaryItem(label: 'VIGENCIA', value: '01 ene - 31 dic 2026')),
          SizedBox(width: 15),
          Expanded(child: _SummaryItem(label: 'TIENDAS CUBIERTAS', value: '184')),
          SizedBox(width: 15),
          Expanded(child: _SummaryItem(label: 'IGUALAS ACTIVAS', value: '184')),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            textBaseline: TextBaseline.alphabetic,
            color: Color(0xFF89A8C6), // #89a8c6
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.textColor,
          ),
        ),
      ],
    );
  }
}
