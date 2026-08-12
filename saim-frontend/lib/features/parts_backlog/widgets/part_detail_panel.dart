import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class PartDetailPanel extends StatelessWidget {
  PartDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalle · SRF-2026-00318',
                    style: TextStyle(
                      color: context.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Malecón · IG-00030 · Unidad condensadora 03',
                    style: TextStyle(
                      color: context.mutedTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              StatusPill(text: 'Crítica', type: StatusType.danger),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildSmallChip(context, 'IG-00030'),
              SizedBox(width: 6),
              _buildSmallChip(context, 'OS-2026-00518'),
              SizedBox(width: 6),
              _buildSmallChip(context, 'COR-2026-00201'),
            ],
          ),
          SizedBox(height: 24),
          _buildProgressCircles(context, ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.red50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFF3A7A7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brecha operativa: 2 piezas',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.red, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'La tienda opera al 75%. Riesgo de pérdida de temperatura si falla el segundo contactor.',
                  style: TextStyle(color: AppColors.red, fontSize: 11),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildDetailRow(context, 'Proveedor responsable', 'Proveedor del cliente'),
          _buildDetailRow(context, 'Fecha requerida', '18 jul 2026'),
          _buildDetailRow(context, 'Última promesa', '25 jul 2026'),
          _buildDetailRow(context, 'Recurrencia', '3 solicitudes / 90 días'),
        ],
      ),
    );
  }

  Widget _buildProgressCircles(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircle(context, 'Necesaria', '4'),
        Expanded(child: Divider(color: context.borderColor)),
        _buildCircle(context, 'Solicitada', '4'),
        Expanded(child: Divider(color: context.borderColor)),
        _buildCircle(context, 'Autorizada', '4'),
        Expanded(child: Divider(color: context.borderColor)),
        _buildCircle(context, 'Suministrada', '2', active: true),
        Expanded(child: Divider(color: context.borderColor)),
        _buildCircle(context, 'Instalada', '2'),
      ],
    );
  }

  Widget _buildCircle(BuildContext context, String label, String value, {bool active = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: context.mutedTextColor),
        ),
        SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: active ? AppColors.blue : AppColors.line, width: active ? 2 : 1),
            color: active ? AppColors.blue50 : Colors.white,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: active ? AppColors.blue : AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallChip(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Color(0xFFB8C8D8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
          Text(value, style: TextStyle(color: context.textColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
