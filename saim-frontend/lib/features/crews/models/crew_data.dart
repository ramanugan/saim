class CrewPerson {
  final String initials;
  final String name;
  final String role;
  final List<String> skills;
  final String availability;

  CrewPerson({
    required this.initials,
    required this.name,
    required this.role,
    required this.skills,
    required this.availability,
  });
}

class AssignedCrew {
  final List<String> initials;
  final String name;
  final String role;
  final String task;
  final String time;
  final String status;
  final bool isConflict;
  final String actionText;
  final bool isExecuting;
  final double? progress;

  AssignedCrew({
    required this.initials,
    required this.name,
    required this.role,
    required this.task,
    required this.time,
    required this.status,
    this.isConflict = false,
    required this.actionText,
    this.isExecuting = false,
    this.progress,
  });
}

class CrewData {
  static final List<CrewPerson> unassigned = [
    CrewPerson(
      initials: 'OS',
      name: 'Óscar Salgado',
      role: 'Refrigeración · Nivel senior',
      skills: ['R-22', 'Eléctrico', 'Conducción'],
      availability: 'Disponible desde 07:00 · Guadalajara',
    ),
    CrewPerson(
      initials: 'EP',
      name: 'Elena Pérez',
      role: 'Aire acondicionado',
      skills: ['UMA', 'Alturas'],
      availability: 'Disponible desde 12:00 · Zapopan',
    ),
  ];

  static final List<AssignedCrew> assigned = [
    AssignedCrew(
      initials: ['JR', 'LM'],
      name: 'Cuadrilla GDL-02',
      role: 'JR responsable · LM auxiliar',
      task: 'Río Nilo · IG-00028',
      time: '21 jul · 08:00-14:00',
      status: 'Traslado estimado: 28 min · sin conflicto',
      actionText: 'Reasignar',
    ),
    AssignedCrew(
      initials: ['AG', 'DR'],
      name: 'Cuadrilla GDL-04',
      role: 'AG responsable · DR auxiliar',
      task: 'Bugambilias · IG-00016',
      time: '21-22 jul · 08:00-17:00',
      status: 'DR tiene correctivo crítico a las 14:00',
      isConflict: true,
      actionText: 'Resolver conflicto',
    ),
  ];

  static final List<AssignedCrew> executing = [
    AssignedCrew(
      initials: ['MC', 'RV'],
      name: 'Cuadrilla NAY-01',
      role: 'Inicio 07:54 · ubicación confirmada',
      task: 'Tepic Centro · IG-00136',
      time: 'Avance 62 % · 4 h 12 min',
      status: '',
      isExecuting: true,
      progress: 0.62,
      actionText: 'Ver servicio',
    ),
  ];
}
