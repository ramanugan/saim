import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum SaimButtonType { primary, secondary, ghost, danger }

class SaimButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final SaimButtonType type;
  final IconData? icon;
  final bool fullWidth;
  final bool small;

  SaimButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = SaimButtonType.primary,
    this.icon,
    this.fullWidth = false,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button;
    
    final padding = small 
        ? EdgeInsets.symmetric(horizontal: 10, vertical: 7)
        : EdgeInsets.symmetric(horizontal: 15, vertical: 10);
        
    final fontSize = small ? 12.0 : 14.0;

    switch (type) {
      case SaimButtonType.primary:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
          child: _buildContent(),
        );
        break;
      case SaimButtonType.secondary:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
          child: _buildContent(),
        );
        break;
      case SaimButtonType.ghost:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.blue,
            backgroundColor: AppColors.blue50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            padding: padding,
            textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
          child: _buildContent(),
        );
        break;
      case SaimButtonType.danger:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.red,
            backgroundColor: AppColors.red50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
              side: BorderSide(color: Color(0xFFF3A7A7)),
            ),
            padding: padding,
            textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
          child: _buildContent(),
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: small ? 14 : 18),
          SizedBox(width: 7),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}
