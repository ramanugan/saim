import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ComparacionDatos extends StatelessWidget {
  ComparacionDatos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comparación de datos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        SizedBox(height: 12),
        _buildCompareCard(context, 
          docLabel: 'Documento',
          docValue: 'Contactor 40 A / 1 pieza',
          capLabel: 'Captura',
          capValue: 'Contactor 40 A / 1 pieza',
          matchText: 'Coincide',
          isWarning: false,
        ),
        SizedBox(height: 8),
        _buildCompareCard(context, 
          docLabel: 'Documento',
          docValue: 'Firma sin sello',
          capLabel: 'Plantilla',
          capValue: 'Sello opcional',
          matchText: 'Aceptable',
          isWarning: true,
        ),
        SizedBox(height: 8),
        _buildCompareCard(context, 
          docLabel: 'Documento',
          docValue: 'Presión LT 31 psi',
          capLabel: 'Captura',
          capValue: 'Presión LT 31 psi',
          matchText: 'Coincide',
          isWarning: false,
        ),
      ],
    );
  }

  Widget _buildCompareCard(BuildContext context, {
    required String docLabel,
    required String docValue,
    required String capLabel,
    required String capValue,
    required String matchText,
    required bool isWarning,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWarning ? AppColors.amber50 : context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isWarning ? AppColors.amber : AppColors.line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(docLabel, style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                      Text(docValue, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(capLabel, style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                      Text(capValue, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isWarning ? AppColors.amber : AppColors.green50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              matchText,
              style: TextStyle(
                color: isWarning ? context.surfaceColor : AppColors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
