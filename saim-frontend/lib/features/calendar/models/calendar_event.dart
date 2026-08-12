import 'package:flutter/material.dart';

enum EventColorType {
  blue,
  green,
  amber,
  gray
}

class CalendarEvent {
  final int id;
  final String title;
  final String subtitle;
  final String details;
  final EventColorType colorType;
  final String time;
  final String actionText;
  final int day;
  final String actionType;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.details,
    required this.colorType,
    required this.time,
    required this.actionText,
    required this.day,
    this.actionType = 'Abrir',
  });
}
