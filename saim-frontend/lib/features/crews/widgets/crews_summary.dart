import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CrewsSummary extends StatelessWidget {
  CrewsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(context, 
              title: 'Disponibles hoy',
              value: '14',
              subtitle: 'de 22 técnicos',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(context, 
              title: 'Asignados',
              value: '17',
              subtitle: '9 cuadrillas',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(context, 
              title: 'Conflictos',
              value: '2',
              subtitle: 'requieren decisión',
              isNegative: true,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(context, 
              title: 'Utilización',
              value: '82 %',
              subtitle: 'semana actual',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    bool isNegative = false,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.mutedTextColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: isNegative ? AppColors.red : AppColors.navy,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
