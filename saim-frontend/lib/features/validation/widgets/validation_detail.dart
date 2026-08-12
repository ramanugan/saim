import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/saim_button.dart';
import 'validation_summary.dart';
import 'checklist_plantilla.dart';
import 'desviacion_tiempo.dart';
import 'comparacion_datos.dart';
import 'comentario_validador.dart';
import '../../../core/theme/app_theme.dart';

class ValidationDetail extends StatelessWidget {
  ValidationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OS-2026-00536',
                      style: TextStyle(
                        color: context.mutedTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pachuca · Preventivo trimestral',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ejecutor: Óscar Salgado · Captura: María López',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.mutedTextColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red,
                        side: BorderSide(color: AppColors.red),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Observar'),
                    ),
                    SizedBox(width: 12),
                    SaimButton(
                      text: 'Validar y cerrar',
                      onPressed: () {},
                      type: SaimButtonType.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ValidationSummary(),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChecklistPlantilla(),
                      SizedBox(height: 24),
                      DesviacionTiempo(),
                    ],
                  ),
                ),
                SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ComparacionDatos(),
                      SizedBox(height: 24),
                      ComentarioValidador(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
