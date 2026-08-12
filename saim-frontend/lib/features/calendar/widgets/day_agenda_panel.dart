import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/calendar_event.dart';
import '../models/calendar_data.dart';
import '../../../core/theme/app_theme.dart';

class DayAgendaPanel extends StatelessWidget {
  final int selectedDay;

  DayAgendaPanel({
    super.key,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final events = CalendarData.getEventsForDay(selectedDay);
    
    // Simulate day of week for July 2026
    // Jul 1 = Wed, so Jul 21 = Tue
    final List<String> weekdays = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    // 1st is Wednesday (index 2)
    final int weekdayIndex = (selectedDay + 1) % 7;
    final String weekdayName = weekdays[weekdayIndex].toUpperCase();

    return Container(
      width: 320, // fixed width for sidebar
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekdayName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.mutedTextColor,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$selectedDay de julio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  events.isEmpty ? 'Sin eventos' : '${events.length} eventos',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          
          // Event List
          // Event List
          events.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No hay eventos programados.',
                      style: TextStyle(color: context.mutedTextColor, fontSize: 13),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      for (int i = 0; i < events.length; i++) ...[
                        _buildAgendaItem(context, events[i]),
                        if (i < events.length - 1) SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAgendaItem(BuildContext context, CalendarEvent event) {
    Color indicatorColor;
    switch (event.colorType) {
      case EventColorType.blue:
        indicatorColor = AppColors.blue;
        break;
      case EventColorType.green:
        indicatorColor = AppColors.green;
        break;
      case EventColorType.amber:
        indicatorColor = AppColors.amber;
        break;
      case EventColorType.gray:
        indicatorColor = AppColors.muted;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left accent border
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16),
          // Time
          SizedBox(
            width: 36,
            child: Text(
              event.time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textColor,
              ),
            ),
          ),
          SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  event.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  event.details,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Action button
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blue,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(event.actionText),
            ),
          ),
        ],
      ),
    );
  }
}
