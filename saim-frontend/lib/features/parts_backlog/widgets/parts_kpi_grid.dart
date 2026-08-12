import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PartsKpiGrid extends StatelessWidget {
  PartsKpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(child: _buildKpiCard(context, Icons.settings, AppColors.blue, 'Piezas necesarias', '146', '58 solicitudes')),
          SizedBox(width: 15),
          Expanded(child: _buildKpiCard(context, Icons.hourglass_empty, AppColors.amber, 'Pendientes de suministro', '43', '18 críticas')),
          SizedBox(width: 15),
          Expanded(child: _buildKpiCard(context, Icons.check, AppColors.green, 'Nivel de restauración', '76 %', 'instaladas / necesarias')),
          SizedBox(width: 15),
          Expanded(child: _buildKpiCard(context, Icons.attach_money, AppColors.red, 'Oportunidad comercial', '\$286 mil', '12 partidas elegibles')),
        ],
      ),
    );
  }

  Widget _buildKpiCard(BuildContext context, IconData icon, Color color, String title, String value, String subtitle) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.mutedTextColor,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: context.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: context.mutedTextColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
