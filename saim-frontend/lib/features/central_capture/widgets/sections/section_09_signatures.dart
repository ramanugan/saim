import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section09Signatures extends StatelessWidget {
  Section09Signatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '09',
          title: 'Entrega y aceptación',
          subtitle: 'El puesto y la obligatoriedad dependen de la plantilla del cliente.',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Técnico responsable (documento original)', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 16),
                          Container(
                            height: 60,
                            alignment: Alignment.center,
                            child: Text('Óscar Salgado', style: TextStyle(fontFamily: 'cursive', fontSize: 24, color: context.textColor)),
                          ),
                          SizedBox(height: 16),
                          Text('Firma visible en documento original · 20 jul 18:30', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Responsable que aceptó (documento original)', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(label: 'Nombre', value: 'Laura Torres', isRequired: true),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: CustomDropdown(
                                  label: 'Puesto',
                                  value: 'Jefa de mantenimiento',
                                  isRequired: true,
                                  items: ['Jefa de mantenimiento', 'Gerente de tienda', 'Jefe de departamento'],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: context.backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Center(
                              child: Text('En producción se mostraría el recorte o archivo de la firma del documento original; no se solicita una nueva firma en oficina.', style: TextStyle(color: context.mutedTextColor, fontSize: 12), textAlign: TextAlign.center),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Firma dentro del recuadro', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
                                child: Text('Limpiar', style: TextStyle(color: AppColors.blue, fontSize: 12)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sello / evidencia equivalente', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 16),
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: context.borderColor),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text('SELLO\nTIENDA', textAlign: TextAlign.center, style: TextStyle(color: context.mutedTextColor, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          ),
                          SizedBox(height: 16),
                          CustomCheckbox(label: 'Se obtuvo sello', isChecked: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              CustomCheckbox(label: 'Confirmo que la captura reproduce el documento original y que el técnico ejecutor, el capturista y la persona que aceptó están correctamente identificados.', isChecked: true),
            ],
          ),
        ),
      ],
    );
  }
}
