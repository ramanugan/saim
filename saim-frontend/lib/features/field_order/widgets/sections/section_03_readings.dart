import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section03Readings extends StatelessWidget {
  Section03Readings({super.key});

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
            number: '03',
            title: 'Lecturas técnicas',
            subtitle: 'Valores y set points requeridos por el formato vigente.',
            trailing: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Otra medición'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: BorderSide(color: context.borderColor),
              ),
            ),
          ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildMeasurementInput(context, 
                label: 'Presión LT',
                value: '32',
                unit: 'psi',
                helperText: 'Set point',
                helperValue: '30',
              ),
              _buildMeasurementInput(context, 
                label: 'Presión MT',
                value: '68',
                unit: 'psi',
                helperText: 'Set point',
                helperValue: '65',
              ),
              _buildMeasurementInput(context, 
                label: 'Nivel de líquido',
                value: '72',
                unit: '%',
                helperText: 'Rango esperado 60-80 %',
              ),
              _buildMeasurementInput(context, 
                label: 'Presión descarga',
                value: '190',
                unit: 'psi',
                helperText: 'Set point',
                helperValue: '185',
              ),
              _buildMeasurementDropdown(context, 
                label: 'Separador de aceite',
                value: 'Normal',
                items: ['Normal', 'Bajo', 'Alto'],
                helperText: 'Inspección visual',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementInput(BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required String helperText,
    String? helperValue,
  }) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.mutedTextColor,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(width: 1, color: context.borderColor),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: context.backgroundColor,
                    alignment: Alignment.center,
                    child: Text(
                      unit,
                      style: TextStyle(fontSize: 13, color: context.mutedTextColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                helperText,
                style: TextStyle(fontSize: 11, color: context.mutedTextColor),
              ),
              if (helperValue != null) ...[
                SizedBox(width: 4),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: context.borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    helperValue,
                    style: TextStyle(fontSize: 11, color: AppColors.ink),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementDropdown(BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required String helperText,
  }) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.mutedTextColor,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.surfaceColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: context.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: context.borderColor),
              ),
            ),
            icon: Icon(Icons.expand_more, size: 16),
            style: TextStyle(
              fontSize: 14,
              color: context.textColor,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (val) {},
          ),
          SizedBox(height: 4),
          Text(
            helperText,
            style: TextStyle(fontSize: 11, color: context.mutedTextColor),
          ),
        ],
      ),
    );
  }
}
