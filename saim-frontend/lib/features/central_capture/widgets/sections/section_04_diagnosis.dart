import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section04Diagnosis extends StatelessWidget {
  Section04Diagnosis({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '04',
          title: 'Diagnóstico y acciones tomadas',
          subtitle: 'Describe hallazgos y trabajo realizado.',
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Diagnóstico y acciones',
                value: 'Se realizó limpieza general, revisión de presiones, reapriete de terminales y pruebas de operación. Se detectó desgaste en un contactor de 40 A; el equipo queda operativo y se genera la solicitud de refacción vinculada.',
                isRequired: true,
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildCheckbox(context, 'Equipo operativo al concluir', true),
                  _buildCheckbox(context, 'Solución provisional', false),
                  _buildCheckbox(context, 'Se detectó hallazgo correctivo', true),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.blue,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Crear correctivo vinculado', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(BuildContext context, String label, bool value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: (v) {},
            activeColor: AppColors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: context.borderColor),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: context.textColor),
        ),
      ],
    );
  }
}
