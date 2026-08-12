import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/status_pill.dart';

class PriorityServicesTable extends StatefulWidget {
  PriorityServicesTable({super.key});

  @override
  State<PriorityServicesTable> createState() => _PriorityServicesTableState();
}

class _PriorityServicesTableState extends State<PriorityServicesTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Servicios prioritarios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Atenciones que requieren acción',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  textStyle: TextStyle(fontWeight: FontWeight.w600),
                ),
                child: Text('Abrir calendario'),
              ),
            ],
          ),
          SizedBox(height: 24),
          // DataTable can be overflowing on small screens, so wrap in SingleChildScrollView
          LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dataTableTheme: DataTableThemeData(
                          dataTextStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: context.textColor,
                          ),
                          headingTextStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.mutedTextColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(context.isDarkMode ? context.backgroundColor : Color(0xFFF3F6FA)),
                        headingRowHeight: 40,
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 56,
                        dividerThickness: 1,
                        horizontalMargin: 16,
                        columnSpacing: 16,
                        columns: [
                          DataColumn(label: Text('TIENDA / IGUALA')),
                          DataColumn(label: Text('TIPO')),
                  DataColumn(label: Text('PROGRAMACIÓN / SLA')),
                  DataColumn(label: Text('CUADRILLA')),
                  DataColumn(label: Text('ESTADO')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  _buildDataRow(
                    context,
                    title: 'Río Nilo · IG-00028',
                    subtitle: 'Jalisco · Soriana Súper',
                    type: 'Preventivo',
                    sla: 'Hoy 08:00 · 6 h',
                    avatars: ['JR', 'LM'],
                    statusLabel: 'En ejecución',
                    statusType: StatusType.info,
                    actionText: 'Abrir',
                  ),
                  _buildDataRow(
                    context,
                    title: 'Satélite · IG-00078',
                    subtitle: 'Edo. Méx. · Híper',
                    type: 'Correctivo',
                    sla: 'SLA vence en 1 h 20',
                    avatars: ['AG', 'DR'],
                    statusLabel: 'Crítico',
                    statusType: StatusType.danger,
                    actionText: 'Abrir',
                  ),
                  _buildDataRow(
                    context,
                    title: 'Pachuca · IG-00086',
                    subtitle: 'Hidalgo · Mercado',
                    type: 'Preventivo',
                    sla: 'Ayer · 1 jornada',
                    avatars: ['OS'],
                    statusLabel: 'Sin reporte',
                    statusType: StatusType.warning,
                    actionText: 'Capturar',
                  ),
                  _buildDataRow(
                    context,
                    title: 'Malecón · IG-00030',
                    subtitle: 'Jalisco · City Club',
                    type: 'Refacción',
                    sla: '12 días de antigüedad',
                    avatars: [],
                    statusLabel: 'Backlog',
                    statusType: StatusType.danger,
                    actionText: 'Abrir',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String type,
    required String sla,
    required List<String> avatars,
    required String statusLabel,
    required StatusType statusType,
    required String actionText,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: context.textColor)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: context.mutedTextColor)),
            ],
          ),
        ),
        DataCell(Text(type)),
        DataCell(Text(sla)),
        DataCell(
          avatars.isEmpty
              ? Text('—', style: TextStyle(color: context.mutedTextColor))
              : _buildAvatarStack(avatars),
        ),
        DataCell(Transform.scale(
          scale: 0.85,
          alignment: Alignment.centerLeft,
          child: StatusPill(text: statusLabel, type: statusType),
        )),
        DataCell(
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.blue,
              textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              padding: EdgeInsets.zero,
              minimumSize: Size(60, 36),
            ),
            child: Text(actionText),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarStack(List<String> initials) {
    return Builder(
      builder: (context) {
        return SizedBox(
      width: (initials.length * 22.0) + 6.0,
      height: 28,
      child: Stack(
        children: List.generate(initials.length, (index) {
          return Positioned(
            left: index * 22.0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xFFDBEAFE),
                shape: BoxShape.circle,
                border: Border.all(color: context.surfaceColor, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                initials[index],
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: context.textColor),
              ),
            ),
          );
        }),
      ),
    );
    },
    );
  }
}
