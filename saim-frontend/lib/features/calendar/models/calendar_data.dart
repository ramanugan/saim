import 'calendar_event.dart';

class CalendarData {
  // A simple map simulating events grouped by day for July 2026.
  // The keys are day numbers (1-31).
  static final Map<int, List<CalendarEvent>> events = {
    2: [
      CalendarEvent(
        id: 1,
        day: 2,
        time: '08:00',
        title: 'Bugambilias · IG-00016',
        subtitle: 'Híper · 2 días · 2 técnicos',
        details: 'AG / DR · Refrigeración',
        colorType: EventColorType.green,
        actionText: 'Abrir',
      ),
    ],
    3: [
      CalendarEvent(
        id: 2,
        day: 3,
        time: '10:00',
        title: 'Río Nilo · IG-00028',
        subtitle: 'Súper · 6 h',
        details: 'Refrigeración',
        colorType: EventColorType.blue,
        actionText: 'Abrir',
      ),
    ],
    6: [
      CalendarEvent(
        id: 3,
        day: 6,
        time: '08:00',
        title: 'Pachuca · IG-00086',
        subtitle: '1 día',
        details: 'Aire acondicionado',
        colorType: EventColorType.amber,
        actionText: 'Abrir',
      ),
    ],
    8: [
      CalendarEvent(
        id: 4,
        day: 8,
        time: '09:00',
        title: 'Cordilleras · IG-00061',
        subtitle: '1 día',
        details: 'Refrigeración',
        colorType: EventColorType.blue,
        actionText: 'Abrir',
      ),
    ],
    21: [
      CalendarEvent(
        id: 5,
        day: 21,
        time: '08:00',
        title: 'Río Nilo · IG-00028',
        subtitle: 'Súper · 6 h · 2 técnicos',
        details: 'JR / LM · Refrigeración',
        colorType: EventColorType.blue,
        actionText: 'Abrir',
      ),
      CalendarEvent(
        id: 6,
        day: 21,
        time: '09:00',
        title: 'Bugambilias · IG-00016',
        subtitle: 'Híper · 2 días · 2 técnicos',
        details: 'AG / DR · Refrigeración',
        colorType: EventColorType.green,
        actionText: 'Abrir',
      ),
      CalendarEvent(
        id: 7,
        day: 21,
        time: '12:00',
        title: 'Cordilleras · IG-00061',
        subtitle: 'Mercado · 1 día · 2 técnicos',
        details: 'Conflicto de traslado',
        colorType: EventColorType.amber,
        actionText: 'Resolver',
      ),
      CalendarEvent(
        id: 8,
        day: 21,
        time: '16:00',
        title: 'Visita de supervisión',
        subtitle: 'Zona Occidente · 1 técnico',
        details: 'OS · ruta GDL',
        colorType: EventColorType.gray,
        actionText: 'Abrir',
      ),
    ],
    24: [
      CalendarEvent(
        id: 9,
        day: 24,
        time: '08:00',
        title: 'Tepic Centro · IG-00045',
        subtitle: 'Súper · 6 h',
        details: 'Refrigeración',
        colorType: EventColorType.blue,
        actionText: 'Abrir',
      ),
    ],
  };

  static List<CalendarEvent> getEventsForDay(int day) {
    return events[day] ?? [];
  }
}
