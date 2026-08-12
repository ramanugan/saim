import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class EmbudoCobroPanel extends StatelessWidget {
  EmbudoCobroPanel({super.key});

  Widget _buildStage(BuildContext context, String label, String amount, String subtitle) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: context.mutedTextColor)),
            SizedBox(height: 4),
            Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
            SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.blue2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Embudo de liberación y cobro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 4),
                Text('Identifica la etapa que detiene cada importe', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStage(context, 'Trabajo aceptado', '\$486 mil', '8 expedientes'),
                _buildArrow(context, ),
                _buildStage(context, 'Pendiente de pedido', '\$164 mil', '3 expedientes'),
                _buildArrow(context, ),
                _buildStage(context, 'Listo para facturar', '\$122 mil', '1 expediente'),
                _buildArrow(context, ),
                _buildStage(context, 'Facturado', '\$1.16 M', '22 facturas'),
                _buildArrow(context, ),
                _buildStage(context, 'Cobrado', '\$305 mil', '8 pagos'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
