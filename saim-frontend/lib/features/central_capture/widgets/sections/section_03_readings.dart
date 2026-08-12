import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section03Readings extends StatelessWidget {
  Section03Readings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '03',
          title: 'Lecturas técnicas',
          subtitle: 'Valores y set points requeridos por el formato vigente.',
          trailing: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.navy,
              side: BorderSide(color: context.borderColor),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text('＋ Otra medición', style: TextStyle(fontSize: 12)),
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
            columns: 5,
            children: [
              MeasurementInput(label: 'Presión LT', value: '31', unit: 'psi', helperText: 'Set point 30'),
              MeasurementInput(label: 'Presión MT', value: '64', unit: 'psi', helperText: 'Set point 65'),
              MeasurementInput(label: 'Nivel de líquido', value: '68', unit: '%', helperText: 'Rango esperado 60-80 %'),
              MeasurementInput(label: 'Presión descarga', value: '185', unit: 'psi', helperText: 'Set point 180'),
              MeasurementInput(label: 'Separador de aceite', value: 'Normal', isDropdown: true, helperText: 'Inspección visual'),
            ],
          ),
        ),
      ],
    );
  }
}

class MeasurementInput extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String helperText;
  final bool isDropdown;

  MeasurementInput({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    required this.helperText,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDropdown) {
      return CustomDropdown(
        label: label,
        value: value,
        items: [value],
      );
    }
    return CustomTextField(
      label: label,
      value: value,
      placeholder: unit,
    );
  }
}
