import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class CustodiaHerramientasList extends StatelessWidget {
  CustodiaHerramientasList({super.key});

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Custodia de herramientas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                      SizedBox(height: 4),
                      Text('Activos reutilizables', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showDialog(context, 'Inventario completo');
                  },
                  child: Text('Inventario completo', style: TextStyle(color: AppColors.blue, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'Bomba de vacío · HT-00418', 'Custodio: Arturo Gómez · COR-2026-00204', 'Vence hoy', StatusType.warning),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'Detector electrónico · HT-00302', 'Custodio: Diego Ríos · COR-2026-00208', 'En plazo', StatusType.success),
          Divider(height: 1, color: context.borderColor),
          _buildItem(context, 'Manifold digital · HT-00198', 'Custodio: José Ramírez · OS-2026-00541', 'En plazo', StatusType.success),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String name, String subtitle, String statusText, StatusType type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFE8F2FB), // AppColors.blue50
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(Icons.flash_on, size: 16, color: AppColors.blue),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
              ],
            ),
          ),
          StatusPill(text: statusText, type: type),
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
