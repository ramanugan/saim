import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ValidationSummary extends StatelessWidget {
  ValidationSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.borderColor),
          bottom: BorderSide(color: context.borderColor),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(context, 'Fecha real', '20 jul 2026'),
          _buildItem(context, 'Duración', '10 h 15 min'),
          _buildItem(context, 'Desviación', '+ 2 h 15', isNegative: true),
          _buildItem(context, 'Documento original', 'Adjunto'),
          _buildItem(context, 'Evidencias', '4 archivos'),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String label, String value, {bool isNegative = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.mutedTextColor,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isNegative ? AppColors.red : AppColors.navy,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
