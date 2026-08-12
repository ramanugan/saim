import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/saim_button.dart';

class DashboardFilterStrip extends StatelessWidget {
  DashboardFilterStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _buildFilterItem(context, 'Cliente', 'Soriana', ['Soriana', 'Walmart']),
          _buildFilterItem(context, 'Contrato', 'Mantenimiento nacional 2026', ['Mantenimiento nacional 2026', 'Igualas Regionales']),
          _buildFilterItem(context, 'Zona', 'Todas las zonas', ['Todas las zonas', 'Occidente', 'Norte', 'Centro', 'Sureste']),
          _buildFilterItem(context, 'Periodo', 'Julio 2026', ['Julio 2026', 'Junio 2026']),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: SaimButton(
              text: 'Aplicar',
              type: SaimButtonType.secondary,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(BuildContext context, String label, String value, List<String> options) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 6),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: context.borderColor),
              borderRadius: BorderRadius.circular(8),
              color: context.surfaceColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, size: 20, color: context.mutedTextColor),
                style: TextStyle(
                  fontSize: 14,
                  color: context.textColor,
                  fontFamily: 'Inter',
                ),
                onChanged: (String? newValue) {},
                items: options.map<DropdownMenuItem<String>>((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
