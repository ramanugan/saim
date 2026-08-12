import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class DocumentosFaltantesList extends StatelessWidget {
  DocumentosFaltantesList({super.key});

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
                Text('Documentos faltantes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 4),
                Text('Bloqueos de facturación', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'Pedido del cliente', 'COR-2026-00204 · \$86,400', AppColors.red),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'Firma de aceptación', 'COR-2026-00188 · \$44,200', AppColors.amber),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'Datos fiscales', 'COR-2026-00184 · \$33,400', AppColors.amber),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String subtitle, Color dotColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
              ],
            ),
          ),
          SizedBox(width: 16),
          TextButton(
            onPressed: () {
              _showDialog(context, 'Gestionar \$title');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size(0, 0),
              backgroundColor: context.backgroundColor,
            ),
            child: Text('Gestionar', style: TextStyle(fontSize: 12, color: AppColors.blue)),
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
