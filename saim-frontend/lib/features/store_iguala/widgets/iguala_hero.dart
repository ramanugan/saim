import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class IgualaHero extends StatelessWidget {
  IgualaHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Store Identity
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.textColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: context.surfaceColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Soriana Mercado Pachuca',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Determinante 86 · Pachuca de Soto, Hidalgo',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Contrato Mantenimiento nacional 2026 / Zona Centro',
                        style: TextStyle(
                          fontSize: 10,
                          color: context.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Metrics
          _buildMetric(context, 'Cuota preventiva', '\$14,800', 'por trimestral'),
          _buildMetric(context, 'Próximo preventivo', '20 jul', '00:00 · 8 horas'),
          _buildMetric(context, 'Cumplimiento anual', '96 %', '5 de 5 dentro de ventana'),
          _buildMetric(context, 'Margen acumulado', '31.4 %', 'preventivo + correctivo'),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, String subLabel) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: context.borderColor),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: context.mutedTextColor,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 10,
                color: context.mutedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
