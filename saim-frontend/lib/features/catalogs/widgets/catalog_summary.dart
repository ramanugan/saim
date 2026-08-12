import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CatalogSummary extends StatelessWidget {
  CatalogSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Expanded(child: _SummaryBox(label: 'CLIENTES', value: '3', note: '1 activo en el escenario')),
          SizedBox(width: 15),
          Expanded(child: _SummaryBox(label: 'TIENDAS', value: '10', note: '6 tipos de tienda')),
          SizedBox(width: 15),
          Expanded(child: _SummaryBox(label: 'EQUIPOS', value: '10', note: 'relacionados por tienda')),
          SizedBox(width: 15),
          Expanded(child: _SummaryBox(label: 'REFACCIONES', value: '10', note: 'con stock y reorden')),
          SizedBox(width: 15),
          Expanded(child: _SummaryBox(label: 'PERSONAS', value: '14', note: 'campo y oficina')),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;
  final String note;

  const _SummaryBox({
    required this.label,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: context.textColor,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.0,
            ),
          ),
          SizedBox(height: 5),
          Text(
            note,
            style: TextStyle(
              fontSize: 11,
              color: context.mutedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
