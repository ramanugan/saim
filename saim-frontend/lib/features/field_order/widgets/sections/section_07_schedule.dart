import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../form/custom_inputs.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section07Schedule extends StatelessWidget {
  Section07Schedule({super.key});

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
            number: '07',
            title: 'Jornada y cuadrilla participante',
            subtitle: 'Tiempo calendario, efectivo y horas-hombre se calculan por separado.',
          ),
          FormGrid(
            children: [
              _buildTimeInput(context, 'Llegada', '07:54'),
              _buildTimeInput(context, 'Inicio efectivo', '08:07'),
              _buildTimeInput(context, 'Fin efectivo', '13:49'),
              _buildTimeInput(context, 'Salida', '14:02'),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pausas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.mutedTextColor)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: '20',
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(context),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('minutos', style: TextStyle(fontSize: 12, color: AppColors.ink)),
                    ],
                  ),
                ],
              ),
              CustomTextField(label: 'Tiempo efectivo', value: '5 h 22 min', isReadOnly: true),
              CustomTextField(label: 'Horas-hombre', value: '10 h 44 min', isReadOnly: true),
              _buildDeviationField(context, 'Desviación', '- 38 min'),
            ],
          ),
          SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _buildParticipant(context, 'JR', 'José Ramírez', 'Responsable · 5 h 22 min'),
              _buildParticipant(context, 'LM', 'Laura Méndez', 'Auxiliar · 5 h 22 min'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.mutedTextColor)),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: _inputDecoration(context).copyWith(
            suffixIcon: Icon(Icons.access_time, size: 16, color: context.mutedTextColor),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviationField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.mutedTextColor)),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w600),
          decoration: _inputDecoration(context).copyWith(
            fillColor: AppColors.green.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(BuildContext context, String initials, String name, String detail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.blue50,
            child: Text(initials, style: TextStyle(color: AppColors.blue, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textColor)),
              Text(detail, style: TextStyle(fontSize: 11, color: AppColors.ink)),
            ],
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.green.withOpacity(0.5)),
            ),
            child: Text(
              'Confirmado',
              style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: context.surfaceColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: context.borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: context.borderColor)),
    );
  }
}
