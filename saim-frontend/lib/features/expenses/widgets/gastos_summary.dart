import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class GastosSummary extends StatelessWidget {
  GastosSummary({super.key});

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
          title: 'Gasto del mes',
          value: '\$428,640',
          subtitle: '+ 3.2 % vs presupuesto',
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Por comprobar',
          value: '\$38,500',
          subtitle: '6 anticipos · 2 vencidos',
          isNegative: true,
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Combustible',
          value: '\$184,260',
          subtitle: '8.7 km/l promedio',
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Gastos rechazados',
          value: '\$6,420',
          subtitle: '4 comprobantes',
        ),
        SizedBox(width: 16),
        _buildKpiCard(context, 
          title: 'Herramientas en custodia',
          value: '36',
          subtitle: '2 devoluciones vencidas',
        ),
      ],
    );
  }
}
