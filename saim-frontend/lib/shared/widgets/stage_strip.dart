import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class StageItem {
  final String label;
  final String value;
  final String subtitle;

  StageItem({
    required this.label,
    required this.value,
    required this.subtitle,
  });
}

class StageStrip extends StatelessWidget {
  final List<StageItem> items;

  StageStrip({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: context.textColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: _buildItems(context),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    List<Widget> rowItems = [];
    for (int i = 0; i < items.length; i++) {
      rowItems.add(
        Expanded(
          child: Column(
            children: [
              Text(
                items[i].label,
                style: TextStyle(
                  color: Color(0xFF90A4AE), // AppColors.muted version for dark bg
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                items[i].value,
                style: TextStyle(
                  color: context.surfaceColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                items[i].subtitle,
                style: TextStyle(
                  color: context.surfaceColor.withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );

      if (i < items.length - 1) {
        rowItems.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.chevron_right,
              color: context.surfaceColor.withOpacity(0.3),
              size: 20,
            ),
          ),
        );
      }
    }
    return rowItems;
  }
}
