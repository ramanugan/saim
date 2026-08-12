import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ComentarioValidador extends StatelessWidget {
  ComentarioValidador({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentario del validador',
          style: TextStyle(
            fontSize: 13,
            color: context.mutedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Agrega observación cuando corresponda...',
            hintStyle: TextStyle(color: context.mutedTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: context.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.blue),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
