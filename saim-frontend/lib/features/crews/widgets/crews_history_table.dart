import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CrewsHistoryTable extends StatefulWidget {
  CrewsHistoryTable({super.key});

  @override
  State<CrewsHistoryTable> createState() => _CrewsHistoryTableState();
}

class _CrewsHistoryTableState extends State<CrewsHistoryTable> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'Historial de reasignaciones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Nunca se sobrescribe la asignación anterior',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          
          // Table
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
                    child: DataTable(
              headingTextStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: context.mutedTextColor,
                letterSpacing: 1,
              ),
              dataTextStyle: TextStyle(
                fontSize: 13,
                color: AppColors.ink,
              ),
              dividerThickness: 1,
              headingRowColor: MaterialStateProperty.all(context.backgroundColor),
              columns: [
                DataColumn(label: Text('FECHA/HORA')),
                DataColumn(label: Text('SERVICIO')),
                DataColumn(label: Text('ANTERIOR')),
                DataColumn(label: Text('NUEVA')),
                DataColumn(label: Text('MOTIVO')),
                DataColumn(label: Text('AUTORIZÓ')),
              ],
              rows: [
                _buildDataRow(
                  fecha: '20 jul · 16:42',
                  servicio: 'IG-00061 / 21 jul',
                  anterior: 'OS / EP',
                  nueva: 'OS / CP',
                  motivo: 'Prioridad correctiva de EP',
                  autorizo: 'Adriana Méndez',
                ),
                _buildDataRow(
                  fecha: '18 jul · 09:12',
                  servicio: 'COR-2026-00208',
                  anterior: 'AG / DR',
                  nueva: 'AG / DR / LM',
                  motivo: 'Emergencia · personal adicional',
                  autorizo: 'Jorge Soto',
                ),
              ],
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

  DataRow _buildDataRow({
    required String fecha,
    required String servicio,
    required String anterior,
    required String nueva,
    required String motivo,
    required String autorizo,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(fecha)),
        DataCell(Text(servicio)),
        DataCell(Text(anterior)),
        DataCell(Text(nueva)),
        DataCell(Text(motivo)),
        DataCell(Text(autorizo)),
      ],
    );
  }
}

