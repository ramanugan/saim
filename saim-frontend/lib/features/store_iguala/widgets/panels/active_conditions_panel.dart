import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class ActiveConditionsPanel extends StatelessWidget {
  ActiveConditionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Condiciones vigentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Aplicación desde 01 ene 2026',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          
          // Data List
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _buildRow(context, 'Periodicidad', 'Trimestral'),
                _buildRow(context, 'Duración estándar', '8 horas efectivas'),
                _buildRow(context, 'Jornadas', '1'),
                _buildRow(context, 'Cuadrilla', '2 técnicos'),
                _buildRow(context, 'Tolerancia', '± 60 minutos'),
                _buildRow(context, 'Facturación', 'Trimestral'),
                _buildRow(context, 'SLA correctivo', 'Respuesta 2 h · llegada 6 h'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: context.mutedTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: context.textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
