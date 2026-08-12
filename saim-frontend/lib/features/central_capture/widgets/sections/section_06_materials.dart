import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../../core/theme/app_theme.dart';

class Section06Materials extends StatelessWidget {
  Section06Materials({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '06',
          title: 'Materiales utilizados',
          subtitle: 'Consumo realizado durante el servicio.',
          trailing: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.navy,
              side: BorderSide(color: context.borderColor),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text('＋ Agregar', style: TextStyle(fontSize: 12)),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.borderColor),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
              headingRowColor: WidgetStateProperty.all(context.surfaceColor),
              columns: [
                DataColumn(label: Text('Cantidad')),
                DataColumn(label: Text('Material')),
                DataColumn(label: Text('Unidad')),
                DataColumn(label: Text('Observación')),
                DataColumn(label: Text('')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: '1',
                        decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    )),
                    DataCell(SizedBox(
                      width: 200,
                      child: TextFormField(
                        initialValue: 'Limpiador dieléctrico',
                        decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    )),
                    DataCell(SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: 'Pieza',
                        items: ['Pieza', 'Litro', 'Metro'].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) {},
                        decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    )),
                    DataCell(SizedBox(
                      width: 250,
                      child: TextFormField(
                        initialValue: 'Aplicación en terminales y contactor',
                        decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    )),
                    DataCell(IconButton(
                      icon: Icon(Icons.close, color: context.mutedTextColor),
                      onPressed: () {},
                    )),
                  ],
                ),
              ],
            ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
