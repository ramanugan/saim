import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CalendarToolbar extends StatelessWidget {
  CalendarToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Segmented Control (Mes, Semana, Lista)
          Container(
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.borderColor),
            ),
            child: Row(
              children: [
                _buildSegmentButton(context, 'Mes', isActive: true),
                Container(width: 1, height: 24, color: context.borderColor),
                _buildSegmentButton(context, 'Semana'),
                Container(width: 1, height: 24, color: context.borderColor),
                _buildSegmentButton(context, 'Lista'),
              ],
            ),
          ),
          
          // Period navigation
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_left, color: context.textColor),
                splashRadius: 20,
              ),
              SizedBox(width: 16),
              Text(
                'Julio 2026',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_right, color: context.textColor),
                splashRadius: 20,
              ),
              SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  backgroundColor: AppColors.blue50,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                child: Text('Hoy'),
              ),
            ],
          ),

          // Filters
          Row(
            children: [
              _buildDropdown(context, 'Todas las zonas'),
              SizedBox(width: 12),
              _buildDropdown(context, 'Todos los estados'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(BuildContext context, String text, {bool isActive = false}) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isActive ? AppColors.blue50 : Colors.transparent,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.blue : AppColors.muted,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, size: 16, color: context.mutedTextColor),
        ],
      ),
    );
  }
}
