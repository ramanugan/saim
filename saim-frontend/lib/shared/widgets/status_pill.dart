import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum StatusType { success, info, warning, danger, neutral }

class StatusPill extends StatelessWidget {
  final String text;
  final StatusType type;
  final bool large;

  StatusPill({
    Key? key,
    required this.text,
    this.type = StatusType.neutral,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case StatusType.success:
        backgroundColor = AppColors.green50;
        textColor = AppColors.green;
        break;
      case StatusType.info:
        backgroundColor = Color(0xFFE8F2FB);
        textColor = AppColors.blue;
        break;
      case StatusType.warning:
        backgroundColor = AppColors.amber50;
        textColor = AppColors.amber;
        break;
      case StatusType.danger:
        backgroundColor = AppColors.red50;
        textColor = AppColors.red;
        break;
      case StatusType.neutral:
        backgroundColor = Color(0xFFEDF1F5);
        textColor = Color(0xFF596776);
        break;
    }

    return Container(
      padding: large 
          ? EdgeInsets.symmetric(horizontal: 12, vertical: 7)
          : EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: large ? 11 : 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
