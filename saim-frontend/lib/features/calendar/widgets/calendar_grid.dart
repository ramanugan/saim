import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/calendar_event.dart';
import '../models/calendar_data.dart';
import '../../../core/theme/app_theme.dart';

class CalendarGrid extends StatelessWidget {
  final int selectedDay;
  final Function(int) onDaySelected;

  CalendarGrid({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          _buildWeekdaysHeader(context, ),
          Divider(height: 1, color: context.borderColor),
          _buildGrid(context, ),
        ],
      ),
    );
  }

  Widget _buildWeekdaysHeader(BuildContext context) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return Row(
      children: days.map((day) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.mutedTextColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid(BuildContext context) {
    // Hardcoded for July 2026 for prototype
    // Starts on Wednesday, so we need 2 days from previous month
    // Ends on Friday, so we need 2 days from next month to complete 5 weeks (35 days)
    
    List<Widget> rows = [];
    int currentDay = 1;
    
    for (int week = 0; week < 5; week++) {
      List<Widget> cells = [];
      for (int dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++) {
        bool isOutside = false;
        int displayDay;
        
        if (week == 0 && dayOfWeek < 2) {
          isOutside = true;
          displayDay = 29 + dayOfWeek; // 29, 30 of June
        } else if (currentDay > 31) {
          isOutside = true;
          displayDay = currentDay - 31; // 1, 2 of August
          currentDay++;
        } else {
          displayDay = currentDay;
          currentDay++;
        }
        
        cells.add(Expanded(
          child: _buildDayCell(context, displayDay, isOutside),
        ));
      }
      rows.add(IntrinsicHeight(child: Row(children: cells)));
      if (week < 4) {
        rows.add(Divider(height: 1, color: context.borderColor));
      }
    }
    
    return Column(children: rows);
  }

  Widget _buildDayCell(BuildContext context, int day, bool isOutside) {
    final bool isSelected = !isOutside && day == selectedDay;
    final List<CalendarEvent> dayEvents = isOutside ? [] : CalendarData.getEventsForDay(day);

    return MouseRegion(
      cursor: isOutside ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (!isOutside) {
            onDaySelected(day);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: BoxConstraints(minHeight: 120),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue50 : Colors.transparent,
            border: Border(
              right: BorderSide(color: context.borderColor),
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isOutside ? AppColors.line : (isSelected ? AppColors.blue : AppColors.ink),
                ),
              ),
              SizedBox(height: 8),
              ...dayEvents.map((e) => _buildEventPill(context, e)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventPill(BuildContext context, CalendarEvent event) {
    Color bgColor;
    Color textColor;

    switch (event.colorType) {
      case EventColorType.blue:
        bgColor = AppColors.blue100;
        textColor = AppColors.blue;
        break;
      case EventColorType.green:
        bgColor = AppColors.green50;
        textColor = AppColors.green;
        break;
      case EventColorType.amber:
        bgColor = AppColors.amber50;
        textColor = AppColors.amber;
        break;
      case EventColorType.gray:
        bgColor = AppColors.line;
        textColor = AppColors.navy;
        break;
    }

    // Short title for the pill (e.g. "Río Nilo · 6 h")
    String pillText = event.title.split('·')[0].trim();
    if (event.subtitle.isNotEmpty) {
      pillText += ' · ${event.subtitle.split('·')[0].trim()}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        pillText,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
