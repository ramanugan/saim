import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/saim_button.dart';
import '../../../core/theme/app_theme.dart';

class ValidationHeader extends StatelessWidget {
  ValidationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Control documental',
              style: TextStyle(
                color: context.mutedTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Validación de órdenes',
              style: TextStyle(
                color: context.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Compara captura, original, evidencia y reglas de la plantilla.',
              style: TextStyle(
                color: context.mutedTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        SaimButton(
          text: 'Asignar validador',
          onPressed: () {},
          type: SaimButtonType.secondary,
        ),
      ],
    );
  }
}
