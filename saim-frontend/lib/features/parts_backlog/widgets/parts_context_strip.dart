import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PartsContextStrip extends StatelessWidget {
  final String title;
  final String subtitle;

  PartsContextStrip({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Text(
            'CONTEXTO SELECCIONADO',
            style: TextStyle(
              color: context.mutedTextColor,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: context.textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(
                color: context.mutedTextColor,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLinkChip(context, 'Abrir iguala'),
              SizedBox(width: 6),
              _buildLinkChip(context, 'Abrir orden'),
              SizedBox(width: 6),
              _buildLinkChip(context, 'Abrir correctivo'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkChip(BuildContext context, String text) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Color(0xFFB8C8D8)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.blue,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
