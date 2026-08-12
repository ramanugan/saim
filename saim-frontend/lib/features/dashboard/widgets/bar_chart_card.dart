import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/status_pill.dart';

class BarChartCard extends StatelessWidget {
  BarChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cumplimiento preventivo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Programado contra ejecutado por zona',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              StatusPill(text: 'Julio 2026', type: StatusType.neutral),
            ],
          ),
          SizedBox(height: 32),
          _buildBarRow(context, 'Occidente', 0.96),
          SizedBox(height: 16),
          _buildBarRow(context, 'Norte', 0.91),
          SizedBox(height: 16),
          _buildBarRow(context, 'Centro', 0.94),
          SizedBox(height: 16),
          _buildBarRow(context, 'Sureste', 0.88),
          SizedBox(height: 32),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Cumplimiento', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                ],
              ),
              SizedBox(width: 16),
              Row(
                children: [
                  Container(width: 2, height: 12, color: AppColors.amber),
                  SizedBox(width: 8),
                  Text('Meta 92 %', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBarRow(BuildContext context, String label, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textColor),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // Track background
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.blue50.withOpacity(context.isDarkMode ? 0.1 : 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Fill
                  Container(
                    width: constraints.maxWidth * percentage,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Target line (92%)
                  Positioned(
                    left: constraints.maxWidth * 0.92,
                    top: -4,
                    bottom: -4,
                    child: Container(
                      width: 2,
                      color: AppColors.amber,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(width: 16),
        SizedBox(
          width: 40,
          child: Text(
            '${(percentage * 100).toInt()} %',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textColor),
          ),
        ),
      ],
    );
  }
}
