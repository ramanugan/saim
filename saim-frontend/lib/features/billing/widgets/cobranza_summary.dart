import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CobranzaSummary extends StatelessWidget {
  CobranzaSummary({super.key});

  Widget _buildKpiCard(BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    bool isNegative = false,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
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
                fontSize: 12,
                color: context.mutedTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isNegative ? AppColors.red : AppColors.navy,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: context.mutedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildKpiCard(context, 
          title: 'Trabajo aceptado no facturado',
          value: '\$286,400',
          subtitle: '4 correctivos · acción inmediata',
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Por vencer',
          value: '\$742,180',
          subtitle: '12 facturas',
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Vencido 1-30 días',
          value: '\$288,900',
          subtitle: '7 facturas',
          isNegative: true,
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Vencido +30 días',
          value: '\$131,100',
          subtitle: '3 facturas',
          isNegative: true,
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'DSO estimado',
          value: '42 días',
          subtitle: 'meta 35 días',
        ),
      ],
    );
  }
}
