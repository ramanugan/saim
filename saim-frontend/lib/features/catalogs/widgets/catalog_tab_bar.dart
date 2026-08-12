import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CatalogTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  CatalogTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.borderColor)),
      ),
      child: Row(
        children: [
          _TabItem(
            title: 'Cobertura',
            isActive: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          SizedBox(width: 30),
          _TabItem(
            title: 'Tiendas e igualas',
            isActive: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          SizedBox(width: 30),
          _TabItem(
            title: 'Equipos y mediciones',
            isActive: selectedIndex == 2,
            onTap: () => onTabSelected(2),
          ),
          SizedBox(width: 30),
          _TabItem(
            title: 'Personal y cuadrillas',
            isActive: selectedIndex == 3,
            onTap: () => onTabSelected(3),
          ),
          SizedBox(width: 30),
          _TabItem(
            title: 'Refacciones y materiales',
            isActive: selectedIndex == 4,
            onTap: () => onTabSelected(4),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.blue : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.blue : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
