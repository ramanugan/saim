import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'kpi_card.dart';

class KpiGrid extends StatelessWidget {
  KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : (constraints.maxWidth - 24 * 3) / 4,
                child: KpiCard(
                  icon: Icons.grid_view_rounded,
                  iconColor: AppColors.blue,
                  iconBackgroundColor: AppColors.blue50,
                  title: 'Preventivos programados',
                  mainValue: '128',
                  subTextPrefix: '93.8 %',
                  subTextPrefixColor: AppColors.green,
                  subTextSuffix: 'dentro de ventana',
                ),
              ),
              SizedBox(
                width: isMobile ? double.infinity : (constraints.maxWidth - 24 * 3) / 4,
                child: KpiCard(
                  icon: Icons.menu_book_rounded,
                  iconColor: AppColors.amber,
                  iconBackgroundColor: AppColors.amber50,
                  title: 'Pendientes de captura',
                  mainValue: '7',
                  subTextPrefix: '3',
                  subTextPrefixColor: AppColors.ink,
                  subTextSuffix: 'con más de 24 h',
                ),
              ),
              SizedBox(
                width: isMobile ? double.infinity : (constraints.maxWidth - 24 * 3) / 4,
                child: KpiCard(
                  icon: Icons.settings_outlined,
                  iconColor: AppColors.red,
                  iconBackgroundColor: AppColors.red50,
                  title: 'Backlog crítico',
                  mainValue: '18',
                  subTextPrefix: '',
                  subTextPrefixColor: AppColors.muted,
                  subTextSuffix: '\$286 mil de oportunidad',
                ),
              ),
              SizedBox(
                width: isMobile ? double.infinity : (constraints.maxWidth - 24 * 3) / 4,
                child: KpiCard(
                  icon: Icons.attach_money_rounded,
                  iconColor: AppColors.green,
                  iconBackgroundColor: AppColors.green50,
                  title: 'Cuenta por cobrar',
                  mainValue: '\$1.84 M',
                  subTextPrefix: '\$420 mil',
                  subTextPrefixColor: AppColors.red,
                  subTextSuffix: 'vencidos',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
