import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section01Identification extends StatelessWidget {
  Section01Identification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '01',
          title: 'Identificación del servicio',
          subtitle: 'La jerarquía se completa desde el evento programado.',
          trailing: _StatusPill(text: 'Preventivo'),
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
              CustomTextField(
                label: 'Fecha',
                value: '2026-07-20',
                isRequired: true,
              ),
              CustomTextField(
                label: 'Folio interno',
                value: 'OS-2026-00536',
                isReadOnly: true,
              ),
              CustomDropdown(
                label: 'Evento / solicitud vinculada',
                value: 'EV-2026-0720-04 · Preventivo · Pachuca · IG-00086 · 08:00',
                isRequired: true,
                items: ['EV-2026-0720-04 · Preventivo · Pachuca · IG-00086 · 08:00'],
              ),
              CustomTextField(
                label: 'Cliente',
                value: 'Soriana',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Zona',
                value: 'Centro',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Estado / municipio',
                value: 'Hidalgo / Pachuca de Soto',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Sucursal / determinante',
                value: 'Pachuca / 69',
                isReadOnly: true,
              ),
              CustomDropdown(
                label: 'Familia técnica',
                value: 'Refrigeración',
                isRequired: true,
                items: ['Refrigeración'],
              ),
              CustomDropdown(
                label: 'Tipo de mantenimiento',
                value: 'Preventivo programado',
                isRequired: true,
                items: ['Preventivo programado'],
              ),
              CustomTextField(
                label: 'N.º reporte cliente',
                value: '1451122847',
              ),
              CustomTextField(
                label: 'Formato',
                value: 'Soriana v2 - vigente',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Modalidad de captura',
                value: 'Oficina central · transcripción',
                isReadOnly: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;

  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
