import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AccionesCobranzaList extends StatelessWidget {
  AccionesCobranzaList({super.key});

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
                Text('Acciones de cobranza', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 4),
                Text('Seguimiento por responsable', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          _buildActionItem(context, 'Hoy', 'Enviar estado de cuenta', '3 facturas vencidas · responsable: Laura P.', 'Registrar'),
          Divider(height: 1, color: context.borderColor),
          _buildActionItem(context, '22 jul', 'Llamada con CxP cliente', 'F-1848 · compromiso pendiente', 'Ver'),
          Divider(height: 1, color: context.borderColor),
          _buildActionItem(context, '25 jul', 'Escalamiento gerencial', 'Saldo +30 días · \$131,100', 'Ver'),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, String date, String title, String subtitle, String btnText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(date, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.blue)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
              ],
            ),
          ),
          SizedBox(width: 16),
          TextButton(
            onPressed: () {
              _showDialog(context, btnText);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size(0, 0),
              backgroundColor: context.backgroundColor,
            ),
            child: Text(btnText, style: TextStyle(fontSize: 12, color: AppColors.blue)),
          ),
        ],
      ),
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
