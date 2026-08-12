import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/saim_button.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class OpportunityCard extends StatelessWidget {
  OpportunityCard({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oportunidad de suministro',
                    style: TextStyle(
                      color: context.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'La empresa cuenta con disponibilidad',
                    style: TextStyle(
                      color: context.mutedTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              StatusPill(text: 'Elegible', type: StatusType.success),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.green50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '2 × Contactor 40 A',
                  style: TextStyle(color: AppColors.green, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '\$13,800',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'venta estimada antes de impuestos',
                  style: TextStyle(color: AppColors.green, fontSize: 10),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInput(context, 'Stock propio', '6 piezas')),
              SizedBox(width: 12),
              Expanded(child: _buildInput(context, 'Entrega estimada', '24 h')),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInput(context, 'Costo estimado', '\$7,100')),
              SizedBox(width: 12),
              Expanded(child: _buildInput(context, 'Margen estimado', '48.6 %')),
            ],
          ),
          SizedBox(height: 24),
          SaimButton(
            text: 'Crear propuesta para autorización',
            onPressed: () {},
            fullWidth: true,
          ),
          SizedBox(height: 12),
          Center(
            child: Text(
              'No se genera venta sin autorización del cliente.',
              style: TextStyle(color: context.mutedTextColor, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: context.mutedTextColor, fontSize: 11),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFF7F9FB),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: context.borderColor),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: context.textColor,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
