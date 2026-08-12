import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section00Reception extends StatelessWidget {
  Section00Reception({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '00',
          title: 'Recepción y captura central',
          subtitle: 'Se agrega el capturista sin sustituir al técnico ni modificar la información técnica del servicio.',
          trailing: _StatusPill(text: 'Orden en papel'),
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
            children: [
              FormGrid(
                columns: 4,
                children: [
                  CustomDropdown(
                    label: 'Capturista',
                    value: 'María López',
                    isRequired: true,
                    items: ['María López'],
                  ),
                  CustomDropdown(
                    label: 'Técnico ejecutor',
                    value: 'Óscar Salgado',
                    isRequired: true,
                    items: ['Óscar Salgado'],
                  ),
                  CustomTextField(
                    label: 'Fecha y hora de recepción',
                    value: '2026-07-21T17:32',
                    isRequired: true,
                  ),
                  CustomDropdown(
                    label: 'Canal de recepción',
                    value: 'Orden en papel recibida por WhatsApp corporativo',
                    items: ['Orden en papel recibida por WhatsApp corporativo'],
                  ),
                  CustomTextField(
                    label: 'Documento original',
                    value: 'orden_pachuca_200726.jpg',
                    isRequired: true,
                    isReadOnly: true,
                  ),
                  CustomTextField(
                    label: 'Fecha real del servicio',
                    value: '2026-07-20',
                    isRequired: true,
                  ),
                  CustomTextField(
                    label: 'Modalidad de captura',
                    value: 'Oficina central · transcripción',
                    isReadOnly: true,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.amber),
                    SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Regla de ubicación ',
                              style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            TextSpan(
                              text: 'La ubicación de la oficina no se guarda como evidencia del servicio. Se transcribe la coordenada capturada por el técnico o se marca como no disponible.',
                              style: TextStyle(color: context.textColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
        color: AppColors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.amber),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
