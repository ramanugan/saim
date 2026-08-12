import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ContextRibbon extends StatelessWidget {
  ContextRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'Contexto activo',
                style: TextStyle(
                  color: AppColors.blue50,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Soriana · Zona Centro · Pachuca',
                style: TextStyle(
                  color: context.surfaceColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'IG-00086 · OS-2026-00536 · preventivo capturado desde papel',
                style: TextStyle(
                  color: context.surfaceColor.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildRibbonAction(context, 'Abrir iguala'),
              _buildRibbonAction(context, 'Ver evento'),
              _buildRibbonAction(context, 'Ver cola de validación'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRibbonAction(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: context.surfaceColor.withOpacity(0.12),
          side: BorderSide(color: context.surfaceColor.withOpacity(0.45)),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.surfaceColor,
          ),
        ),
      ),
    );
  }
}
