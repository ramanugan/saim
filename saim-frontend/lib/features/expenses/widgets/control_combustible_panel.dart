import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class ControlCombustiblePanel extends StatelessWidget {
  ControlCombustiblePanel({super.key});

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
                    Text('Control de combustible', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textColor)),
                    SizedBox(height: 4),
                    Text('Carga 21 jul · vehículo V-014', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                  ],
                ),
                StatusPill(text: 'En revisión', type: StatusType.info),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _buildMetric(context, 'Litros', '92.40'),
                    SizedBox(width: 8),
                    _buildMetric(context, 'Precio / litro', '\$23.64'),
                    SizedBox(width: 8),
                    _buildMetric(context, 'Importe', '\$2,184.34'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildMetric(context, 'Kilometraje', '84,152 km'),
                    SizedBox(width: 8),
                    _buildMetric(context, 'Rendimiento ruta', '9.1 km/l'),
                    SizedBox(width: 8),
                    _buildMetric(context, 'Capacidad tanque', '110 l'),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F2FB), // AppColors.blue50
                    borderRadius: BorderRadius.circular(4),
                    border: Border(left: BorderSide(color: AppColors.blue, width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Validaciones aprobadas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textColor)),
                      SizedBox(height: 4),
                      Text('Importe = litros × precio dentro de tolerancia; kilometraje creciente; carga compatible con capacidad; comprobante no duplicado.', style: TextStyle(fontSize: 12, color: context.textColor)),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text('Aplicación a órdenes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.textColor)),
                SizedBox(height: 16),
                _buildAllocation(context, 'OS-2026-00541 · Río Nilo', '\$780.00', 0.36),
                SizedBox(height: 12),
                _buildAllocation(context, 'OS-2026-00542 · Bugambilias', '\$904.34', 0.41),
                SizedBox(height: 12),
                _buildAllocation(context, 'OS-2026-00543 · Cordilleras', '\$500.00', 0.23),
                SizedBox(height: 16),
                Divider(height: 1, color: context.borderColor),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total aplicado', style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
                    Text('\$2,184.34', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: context.mutedTextColor)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocation(BuildContext context, String label, String value, double pct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: context.textColor)),
            Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textColor)),
          ],
        ),
        SizedBox(height: 6),
        Stack(
          children: [
            Container(height: 4, decoration: BoxDecoration(color: context.borderColor, borderRadius: BorderRadius.circular(2))),
            FractionallySizedBox(
              widthFactor: pct,
              child: Container(height: 4, decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(2))),
            ),
          ],
        ),
      ],
    );
  }
}
