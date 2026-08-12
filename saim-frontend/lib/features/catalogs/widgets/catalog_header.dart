import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/saim_button.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class CatalogHeader extends StatelessWidget {
  CatalogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DATOS RELACIONADOS DE PRUEBA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Catálogos de demostración',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Clientes, contrato, zonas, tiendas, equipos, personas, refacciones, materiales y proveedores usados en los recorridos.',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              StatusPill(
                text: 'Datos cargados',
                type: StatusType.success,
                large: true,
              ),
              SizedBox(width: 12),
              SaimButton(
                text: 'Restablecer demo',
                type: SaimButtonType.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
