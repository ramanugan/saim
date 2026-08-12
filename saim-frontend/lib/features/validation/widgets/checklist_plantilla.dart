import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ChecklistPlantilla extends StatefulWidget {
  ChecklistPlantilla({super.key});

  @override
  State<ChecklistPlantilla> createState() => _ChecklistPlantillaState();
}

class _ChecklistPlantillaState extends State<ChecklistPlantilla> {
  final Map<String, bool> _checks = {
    'Cliente, tienda y determinante': true,
    'Equipo, modelo y serie': true,
    'Lecturas y set points': true,
    'Diagnóstico y acciones': true,
    'Refacciones y materiales': true,
    'Firma del técnico': true,
    'Sello de la tienda': false,
    'Documento original': true,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Checklist de plantilla',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        SizedBox(height: 12),
        ..._checks.entries.map((entry) {
          final isMissingItem = entry.key == 'Sello de la tienda';
          return _buildCheckItem(
            label: entry.key,
            isChecked: entry.value,
            isMissing: isMissingItem && !entry.value,
            onTap: () {
              setState(() {
                _checks[entry.key] = !entry.value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCheckItem({
    required String label,
    required bool isChecked,
    required bool isMissing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 7.0),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: isMissing ? AppColors.amber50 : context.backgroundColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: isChecked ? AppColors.blue : AppColors.muted,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isMissing ? AppColors.amber : context.textColor,
                fontWeight: isMissing ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
