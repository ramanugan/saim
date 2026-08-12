import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../form/custom_inputs.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section02Equipment extends StatelessWidget {
  Section02Equipment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSectionTitle(
            number: '02',
            title: 'Equipo y problema reportado',
            subtitle: 'Puede agregarse más de un equipo atendido.',
            trailing: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Agregar equipo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: BorderSide(color: context.borderColor),
              ),
            ),
          ),
          FormGrid(
            children: [
              CustomDropdown(
                label: 'Equipo atendido',
                value: 'Rack de refrigeración 01 · Cuarto de máquinas',
                isRequired: true,
                items: [
                  'Rack de refrigeración 01 · Cuarto de máquinas',
                  'Unidad condensadora 03 · Azotea',
                ],
              ),
              CustomTextField(
                label: 'Modelo',
                value: 'FRK-600',
              ),
              CustomTextField(
                label: 'Serie',
                value: 'RN-90811',
              ),
            ],
          ),
          SizedBox(height: 16),
          CustomTextField(
            label: 'Problema reportado / objetivo',
            value: 'Mantenimiento preventivo bimestral conforme al alcance de la iguala.',
            isRequired: true,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
