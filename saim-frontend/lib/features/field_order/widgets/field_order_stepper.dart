import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class FieldOrderStepper extends StatelessWidget {
  FieldOrderStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStep(context, '1', 'Identificación', true),
            _buildDivider(true),
            _buildStep(context, '2', 'Trabajo', true),
            _buildDivider(false),
            _buildStep(context, '3', 'Evidencia', false),
            _buildDivider(false),
            _buildStep(context, '4', 'Firma y envío', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue : context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? AppColors.blue : AppColors.line,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? context.surfaceColor : AppColors.muted,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? AppColors.navy : AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isActive) {
    return Container(
      width: 40,
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: isActive ? AppColors.blue : AppColors.line,
    );
  }
}
