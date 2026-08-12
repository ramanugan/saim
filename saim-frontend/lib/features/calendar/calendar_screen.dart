import 'package:flutter/material.dart';
import '../../shared/layouts/app_layout.dart';
import 'widgets/calendar_header.dart';
import 'widgets/calendar_toolbar.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/day_agenda_panel.dart';
import 'widgets/calendar_control_table.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Mock current selected day to 21 for the prototype
  int _selectedDay = 21;

  void _handleDaySelected(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Calendario preventivo',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarHeader(),
            CalendarToolbar(),
            
            // Grid and Agenda layout
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CalendarGrid(
                      selectedDay: _selectedDay,
                      onDaySelected: _handleDaySelected,
                    ),
                  ),
                  SizedBox(width: 24),
                  DayAgendaPanel(
                    selectedDay: _selectedDay,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            CalendarControlTable(),
          ],
        ),
      ),
    );
  }
}
