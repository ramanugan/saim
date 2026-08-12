import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../form/custom_inputs.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section01Identification extends StatelessWidget {
  Section01Identification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSectionTitle(
            number: '01',
            title: 'Identificación del servicio',
            subtitle: 'La jerarquía se completa desde el evento programado.',
            trailing: Chip(
              label: Text(
                'Preventivo',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppColors.blue50,
              side: BorderSide.none,
            ),
          ),
          FormGrid(
            children: [
              CustomTextField(
                label: 'Fecha',
                value: '2026-07-21',
                isRequired: true,
              ),
              CustomTextField(
                label: 'Folio interno',
                value: 'OS-2026-00541',
                isReadOnly: true,
              ),
              CustomDropdown(
                label: 'Evento / solicitud vinculada',
                value: 'EV-2026-0721-01 · Preventivo · Río Nilo · IG-00028 · 08:00',
                isRequired: true,
                items: [
                  'EV-2026-0721-01 · Preventivo · Río Nilo · IG-00028 · 08:00',
                  'COR-2026-00198 · Correctivo autorizado · Río Nilo',
                ],
              ),
              SizedBox(), // Spacer to match flex/grid layout if needed, though in FormGrid we can let it flow, but the prototype has 'Evento' spanning 2 cols. Since FormGrid doesn't support colSpan yet easily without custom setup, we'll just let it flow into cells. To simulate colSpan we'd need StaggeredGrid, but let's just use empty cells or standard layout. Let's adjust FormGrid to support colSpan later if really needed. For now just let it wrap.
              CustomTextField(
                label: 'Cliente',
                value: 'Soriana',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Zona',
                value: 'Occidente',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Estado / municipio',
                value: 'Jalisco / Guadalajara',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Sucursal / determinante',
                value: 'Río Nilo / 28',
                isReadOnly: true,
              ),
              CustomDropdown(
                label: 'Familia técnica',
                value: 'Refrigeración',
                isRequired: true,
                items: ['Refrigeración', 'Aire acondicionado'],
              ),
              CustomDropdown(
                label: 'Tipo de mantenimiento',
                value: 'Preventivo programado',
                isRequired: true,
                items: ['Preventivo programado', 'Correctivo por falla'],
              ),
              CustomTextField(
                label: 'N.º reporte cliente',
                placeholder: 'Opcional para preventivo',
              ),
              CustomTextField(
                label: 'Formato',
                value: 'Soriana v2 · vigente',
                isReadOnly: true,
              ),
              CustomTextField(
                label: 'Modalidad de captura',
                value: 'En sitio · técnico ejecutor',
                isReadOnly: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
