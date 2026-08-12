import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class AnticiposPendientesList extends StatelessWidget {
  AnticiposPendientesList({super.key});

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
                Text('Anticipos pendientes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 4),
                Text('Bloqueo según política', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'EP', 'Elena Pérez', 'Venció hace 3 días', '\$1,420', 'Revisar', true),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'MC', 'Miguel Cruz', 'Vence mañana', '\$3,800', 'Recordar', false),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'DR', 'Diego Ríos', 'Vence en 4 días', '\$6,250', 'Ver', false),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String initials, String name, String subtitle, String amount, String btnText, bool isDanger) {
    return Container(
      color: isDanger ? Color(0xFFFEF2F2) : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFE2E8F0),
            child: Text(
              initials,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textColor),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
          SizedBox(width: 16),
          TextButton(
            onPressed: () {
              _showDialog(context, btnText);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size(0, 0),
            ),
            child: Text(btnText, style: TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.bold)),
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
