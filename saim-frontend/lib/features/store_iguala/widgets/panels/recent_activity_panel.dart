import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class RecentActivityPanel extends StatelessWidget {
  RecentActivityPanel({super.key});

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actividad reciente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Expediente integral de la tienda',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.blue,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text('Ver historial completo'),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          
          // Timeline
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTimelineItem(
                  context: context,
                  color: AppColors.green,
                  title: 'Preventivo · OS-2026-00536',
                  subtitle: '2026-07-20 · 1 jornada · Pendiente de captura',
                  trailing: 'Orden',
                  isFirst: true,
                ),
                _buildTimelineItem(
                  context: context,
                  color: AppColors.amber,
                  title: 'Refacción · Refrigerante R-22 - cilindro',
                  subtitle: 'Orden preventiva · brecha 1 - 8 días',
                  trailing: 'Parcial',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required Color color,
    required String title,
    required String subtitle,
    required String trailing,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isFirst)
                  Positioned(
                    top: 0,
                    bottom: 24,
                    child: Container(width: 2, color: context.borderColor),
                  ),
                if (!isLast)
                  Positioned(
                    top: 24,
                    bottom: 0,
                    child: Container(width: 2, color: context.borderColor),
                  ),
                Positioned(
                  top: 20,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.textColor,
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
                  ),
                  SizedBox(width: 16),
                  Text(
                    trailing,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.mutedTextColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
