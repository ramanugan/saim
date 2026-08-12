import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/saim_button.dart';

class DashboardHeader extends StatelessWidget {
  DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Para hacerla responsiva
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OPERACIÓN NACIONAL · SEMANA 29',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: context.mutedTextColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tablero de control',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: context.textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Seguimiento de igualas, órdenes, refacciones y recuperación de ingresos.',
                  style: TextStyle(
                    fontSize: 15,
                    color: context.mutedTextColor,
                  ),
                ),
                if (!isDesktop) SizedBox(height: 16),
              ],
            ),
          ),
          // Actions
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SaimButton(
                text: 'Exportar',
                icon: Icons.download_outlined,
                type: SaimButtonType.secondary,
                onPressed: () {},
              ),
              SaimButton(
                text: 'Nueva orden',
                icon: Icons.add,
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
