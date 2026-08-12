import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section05Parts extends StatelessWidget {
  Section05Parts({super.key});

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
            number: '05',
            title: 'Necesidad de refacciones',
            subtitle: 'La necesidad no equivale a suministro ni instalación.',
            trailing: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add, size: 16),
                  label: Text('Agregar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    side: BorderSide(color: context.borderColor),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.blue,
                  ),
                  child: Text('Abrir seguimiento'),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blue50.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.blue50),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.link, color: AppColors.blue, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vinculación automática',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textColor),
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 13, color: AppColors.ink),
                          children: [
                            TextSpan(text: 'Cada necesidad se relaciona con '),
                            TextSpan(text: 'IG-00028', style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(text: ' y '),
                            TextSpan(text: 'OS-2026-00541', style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(text: '. Si se genera un correctivo, también se vincula a su folio. Solo se excluye cuando se selecciona “Solo observación”.'),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildChip(context, 'IG-00028', isLink: true),
                          _buildChip(context, 'OS-2026-00541', isLink: true),
                          _buildChip(context, 'Correctivo: por generar', isLink: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildTable(context, ),
          SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 8,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 13, color: AppColors.ink),
                  children: [
                    TextSpan(text: '1', style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: ' solicitud(es) se crearán al guardar'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 13, color: AppColors.ink),
                  children: [
                    TextSpan(text: 'Origen: '),
                    TextSpan(text: 'IG-00028', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600)),
                    TextSpan(text: ' / '),
                    TextSpan(text: 'OS-2026-00541', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, {required bool isLink}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isLink ? context.surfaceColor : context.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isLink ? FontWeight.w600 : FontWeight.w400,
          color: isLink ? AppColors.blue : AppColors.muted,
        ),
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
          dataRowMinHeight: 48,
          dataRowMaxHeight: 72,
          headingRowColor: WidgetStateProperty.all(context.surfaceColor),
          dividerThickness: 1,
          columns: [
            DataColumn(label: SizedBox(width: 80, child: Text('CANTIDAD\nNECESARIA', maxLines: 2, overflow: TextOverflow.ellipsis))),
            DataColumn(label: SizedBox(width: 250, child: Text('REFACCIÓN / DESCRIPCIÓN', overflow: TextOverflow.ellipsis))),
            DataColumn(label: SizedBox(width: 120, child: Text('CRITICIDAD', overflow: TextOverflow.ellipsis))),
            DataColumn(label: SizedBox(width: 150, child: Text('IMPACTO OPERATIVO', overflow: TextOverflow.ellipsis))),
            DataColumn(label: SizedBox(width: 200, child: Text('SEGUIMIENTO Y VÍNCULO', overflow: TextOverflow.ellipsis))),
            DataColumn(label: Text('')),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(context),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: 'Contactor 40 A · 3 polos',
                          decoration: _inputDecoration(context),
                        ),
                        SizedBox(height: 4),
                        Text('RF-00082 · descripción homologada', style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: 'Alta',
                      decoration: _inputDecoration(context),
                      items: ['Media', 'Alta', 'Crítica'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) {},
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: 'Operación parcial',
                      decoration: _inputDecoration(context),
                      items: ['Sin afectación', 'Operación parcial', 'Fuera de operación'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) {},
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: 'Vincular a iguala y servicio',
                          decoration: _inputDecoration(context),
                          items: ['Vincular a iguala y servicio', 'Solo observación'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (v) {},
                        ),
                        SizedBox(height: 4),
                        Text('IG-00028 · OS-2026-00541', style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
                      ],
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
