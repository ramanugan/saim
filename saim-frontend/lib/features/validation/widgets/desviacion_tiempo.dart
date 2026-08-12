import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class DesviacionTiempo extends StatelessWidget {
  DesviacionTiempo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desviación de tiempo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Clasificación *',
          style: TextStyle(
            fontSize: 13,
            color: context.mutedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: context.borderColor),
            borderRadius: BorderRadius.circular(6),
            color: context.surfaceColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: 'Condición ajena a la cuadrilla',
              icon: Icon(Icons.arrow_drop_down, color: context.mutedTextColor),
              items: ['Condición ajena a la cuadrilla', 'Planeación', 'Falta de competencia']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Motivo / evidencia *',
          style: TextStyle(
            fontSize: 13,
            color: context.mutedTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          maxLines: 3,
          controller: TextEditingController(text: 'Acceso al cuarto de máquinas retrasado 1 h 50 min; se adjunta registro de ingreso.'),
          decoration: InputDecoration(
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
