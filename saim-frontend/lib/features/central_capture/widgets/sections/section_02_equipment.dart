import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section02Equipment extends StatelessWidget {
  Section02Equipment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '02',
          title: 'Equipo y problema reportado',
          subtitle: 'Puede agregarse más de un equipo atendido.',
          trailing: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.navy,
              side: BorderSide(color: context.borderColor),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text('＋ Agregar equipo', style: TextStyle(fontSize: 12)),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.borderColor),
          ),
          child: FormGrid(
            columns: 4,
            children: [
              CustomDropdown(
                label: 'Equipo atendido',
                value: 'Rack de refrigeración 02 · Cuarto de máquinas',
                isRequired: true,
                items: ['Rack de refrigeración 02 · Cuarto de máquinas'],
              ),
              CustomTextField(
                label: 'Modelo',
                value: 'FRK-420',
              ),
              CustomTextField(
                label: 'Serie',
                value: 'PH-12008',
              ),
              CustomTextField(
                label: 'Problema reportado / objetivo',
                value: 'Mantenimiento preventivo trimestral conforme al calendario de la iguala.',
                isRequired: true,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
