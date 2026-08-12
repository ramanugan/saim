import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../shared/widgets/saim_button.dart';
import '../../../core/theme/app_theme.dart';

class AplicacionPagoPanel extends StatelessWidget {
  AplicacionPagoPanel({super.key});

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Aplicación de pago', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                    SizedBox(height: 4),
                    Text('Transferencia TR-220781 · \$74,800', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                  ],
                ),
                StatusPill(text: 'Por conciliar', type: StatusType.info),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAllocationRow(context, 'F-1868 · Cordilleras', 'Saldo \$49,800', '\$49,800', true),
                SizedBox(height: 12),
                _buildAllocationRow(context, 'F-1871 · Malecón', 'Saldo \$98,400', '\$25,000', true),
                SizedBox(height: 16),
                Divider(height: 1, color: context.borderColor),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total aplicado', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                    Text('\$74,800', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                  ],
                ),
                SizedBox(height: 24),
                SaimButton(
                  text: 'Conciliar y registrar aplicaciones',
                  onPressed: () {
                    _showDialog(context, 'Conciliar y registrar aplicaciones');
                  },
                  type: SaimButtonType.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationRow(BuildContext context, String title, String subtitle, String amount, bool checked) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (val) {},
          activeColor: AppColors.blue,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
              Text(subtitle, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
            ],
          ),
        ),
        Container(
          width: 100,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            border: Border.all(color: context.borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(amount, style: TextStyle(fontSize: 14, color: context.textColor), textAlign: TextAlign.right),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('En construcción'),
        content: Text('Acción: \$action'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cerrar')),
        ],
      ),
    );
  }
}
