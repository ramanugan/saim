import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class CalendarControlTable extends StatelessWidget {
  CalendarControlTable({super.key});

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
                  'Control programado contra ejecutado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'El tiempo estándar corresponde a la condición vigente de cada iguala.',
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
              return SingleChildScrollView(
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
                DataColumn(label: Text('FECHA')),
                DataColumn(label: Text('TIENDA')),
                DataColumn(label: Text('TIPO')),
                DataColumn(label: Text('PROGRAMADO')),
                DataColumn(label: Text('EJECUTADO')),
                DataColumn(label: Text('HORAS-HOMBRE')),
                DataColumn(label: Text('DESVIACIÓN')),
                DataColumn(label: Text('ESTADO')),
              ],
              rows: [
                _buildDataRow(
                  fecha: '18 may',
                  tienda: 'Río Nilo',
                  tipo: 'Súper',
                  programado: '6 h / 2 técnicos',
                  ejecutado: '5 h 42 / 2',
                  horasHombre: '11.4 h',
                  desviacion: '- 18 min',
                  desviacionColor: AppColors.green,
                  estado: 'En tiempo',
                  estadoType: StatusType.success,
                ),
                _buildDataRow(
                  fecha: '14 jul',
                  tienda: 'Pachuca',
                  tipo: 'Mercado',
                  programado: '8 h / 2 técnicos',
                  ejecutado: '10 h 15 / 2',
                  horasHombre: '20.5 h',
                  desviacion: '+ 2 h 15',
                  desviacionColor: AppColors.red,
                  estado: 'Por justificar',
                  estadoType: StatusType.warning,
                ),
                _buildDataRow(
                  fecha: '15-17 jul',
                  tienda: 'Bugambilias',
                  tipo: 'Híper',
                  programado: '2 días / 2 técnicos',
                  ejecutado: 'Pendiente',
                  horasHombre: '—',
                  desviacion: '—',
                  desviacionColor: AppColors.muted,
                  estado: 'En progreso',
                  estadoType: StatusType.info,
                ),
              ],
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
    required String tienda,
    required String tipo,
    required String programado,
    required String ejecutado,
    required String horasHombre,
    required String desviacion,
    required Color desviacionColor,
    required String estado,
    required StatusType estadoType,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(fecha)),
        DataCell(Text(tienda)),
        DataCell(Text(tipo)),
        DataCell(Text(programado)),
        DataCell(Text(ejecutado)),
        DataCell(Text(horasHombre)),
        DataCell(Text(
          desviacion,
          style: TextStyle(
            color: desviacionColor,
            fontWeight: FontWeight.w600,
          ),
        )),
        DataCell(StatusPill(text: estado, type: estadoType)),
      ],
    );
  }
}
