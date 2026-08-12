import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../field_order/widgets/form/custom_inputs.dart';
import '../../../../core/theme/app_theme.dart';

class Section07Workforce extends StatelessWidget {
  Section07Workforce({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '07',
          title: 'Jornada y cuadrilla participante',
          subtitle: 'Tiempo calendario, efectivo y horas-hombre se calculan por separado.',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormGrid(
                columns: 4,
                children: [
                  CustomTextField(label: 'Llegada', value: '07:55'),
                  CustomTextField(label: 'Inicio efectivo', value: '08:05'),
                  CustomTextField(label: 'Fin efectivo', value: '18:20'),
                  CustomTextField(label: 'Salida', value: '18:35'),
                  CustomTextField(label: 'Pausas (minutos)', value: '45'),
                  CustomTextField(label: 'Tiempo efectivo', value: '9 h 30 min', isReadOnly: true),
                  CustomTextField(label: 'Horas-hombre', value: '19 h 00 min', isReadOnly: true),
                  CustomTextField(
                    label: 'Desviación',
                    value: '+ 1 h 30 min',
                    isReadOnly: true,
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildParticipant(context, 'OS', 'Óscar Salgado', 'Responsable · 9 h 30 min', 'Ejecutor', AppColors.green),
              _buildParticipant(context, 'EP', 'Elena Pérez', 'Auxiliar · 9 h 30 min', 'Ejecutora', AppColors.green),
              _buildParticipant(context, 'ML', 'María López', 'Capturista · no suma horas técnicas', 'Oficina', AppColors.amber),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(BuildContext context, String initials, String name, String details, String role, Color roleColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.borderColor)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.blue.withOpacity(0.1),
            foregroundColor: AppColors.blue,
            child: Text(initials, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(details, style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: roleColor),
            ),
            child: Text(
              role,
              style: TextStyle(color: roleColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
