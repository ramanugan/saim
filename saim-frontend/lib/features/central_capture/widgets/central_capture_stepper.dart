import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CentralCaptureStepper extends StatelessWidget {
  CentralCaptureStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStep(context, 1, 'Documento recibido', '21 jul · 17:32', true),
            _buildDivider(context, true),
            _buildStep(context, 2, 'En captura', 'María López', true),
            _buildDivider(context, false),
            _buildStep(context, 3, 'Validación', 'Pendiente', false),
            _buildDivider(context, false),
            _buildStep(context, 4, 'Cierre', 'Pendiente', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int number, String title, String subtitle, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue : AppColors.line,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isActive ? context.surfaceColor : AppColors.muted,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.blue : AppColors.muted,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: context.mutedTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context, bool isActive) {
    return Container(
      width: 100,
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: isActive ? AppColors.blue : AppColors.line,
    );
  }
}
