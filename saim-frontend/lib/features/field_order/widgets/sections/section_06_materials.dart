import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section06Materials extends StatelessWidget {
  Section06Materials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormSectionTitle(
            number: '06',
            title: 'Materiales utilizados',
            subtitle: 'Consumo realizado durante el servicio.',
            trailing: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add, size: 16),
              label: Text('Agregar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: BorderSide(color: context.borderColor),
              ),
            ),
          ),
          _buildTable(context, ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: LayoutBuilder(
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
          headingRowColor: MaterialStateProperty.all(context.backgroundColor),
          dividerThickness: 1,
          columns: [
            DataColumn(label: Text('CANTIDAD')),
            DataColumn(label: Text('MATERIAL')),
            DataColumn(label: Text('UNIDAD')),
            DataColumn(label: Text('OBSERVACIÓN')),
            DataColumn(label: Text('')),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue: '2',
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(context),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      initialValue: 'Limpiador dieléctrico',
                      decoration: _inputDecoration(context),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: 'Pieza',
                      decoration: _inputDecoration(context),
                      items: ['Pieza', 'Litro', 'Metro'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) {},
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      initialValue: 'Aplicación en terminales',
                      decoration: _inputDecoration(context),
                    ),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: context.mutedTextColor),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: context.surfaceColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: context.borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: context.borderColor)),
    );
  }
}
