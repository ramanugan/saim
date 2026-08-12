import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ValidationContextLinks extends StatelessWidget {
  ValidationContextLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Text(
            'ORDEN EN REVISIÓN:',
            style: TextStyle(
              color: context.mutedTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 16),
          _buildLinkButton(context, 'OS-2026-00536'),
          SizedBox(width: 8),
          _buildLinkButton(context, 'IG-00086'),
          SizedBox(width: 8),
          _buildLinkButton(context, 'SRF-2026-00309'),
        ],
      ),
    );
  }

  Widget _buildLinkButton(BuildContext context, String text) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: context.borderColor),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.blue,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
