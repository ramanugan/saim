import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/saim_button.dart';
import '../../../core/theme/app_theme.dart';

class CoverageHeader extends StatelessWidget {
  CoverageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CLIENTE → CONTRATO → ZONA → ESTADO → TIENDA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: context.mutedTextColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Contrato y cobertura',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'La inclusión de una tienda es explícita; el estado por sí solo no concede cobertura.',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SaimButton(
                text: '＋ Nueva zona',
                type: SaimButtonType.secondary,
                onPressed: () {},
              ),
              SizedBox(width: 12),
              SaimButton(
                text: '＋ Incluir tienda',
                type: SaimButtonType.primary,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
