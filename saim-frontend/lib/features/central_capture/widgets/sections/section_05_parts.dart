import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../../core/theme/app_theme.dart';

class Section05Parts extends StatelessWidget {
  Section05Parts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '05',
          title: 'Necesidad de refacciones',
          subtitle: 'La necesidad no equivale a suministro ni instalación.',
          trailing: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: BorderSide(color: context.borderColor),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text('＋ Agregar', style: TextStyle(fontSize: 12)),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.muted,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text('Abrir seguimiento', style: TextStyle(fontSize: 12)),
              ),
            ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.05),
                  border: Border(left: BorderSide(color: AppColors.blue, width: 4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, color: AppColors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vinculación automática', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: context.textColor, fontSize: 14),
                              children: [
                                TextSpan(text: 'La necesidad se relaciona con '),
                                TextSpan(text: 'IG-00086', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' y '),
                                TextSpan(text: 'OS-2026-00536', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '. El capturista transcribe la misma información de la orden en papel.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 72,
                  headingRowColor: WidgetStateProperty.all(context.surfaceColor),
                  columns: [
                    DataColumn(label: SizedBox(width: 80, child: Text('Cantidad\nnecesaria', maxLines: 2, overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 250, child: Text('Refacción / descripción', overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 120, child: Text('Criticidad', overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 150, child: Text('Impacto operativo', overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 200, child: Text('Seguimiento y vínculo', overflow: TextOverflow.ellipsis))),
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
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: 'Contactor 40 A · 3 polos',
                                decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                              ),
                              Text('RF-00082 · descripción homologada', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                            ],
                          ),
                        )),
                        DataCell(SizedBox(
                          width: 120,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: 'Alta',
                            items: ['Media', 'Alta', 'Crítica'].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (v) {},
                            decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                          ),
                        )),
                        DataCell(SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: 'Operación parcial',
                            items: ['Sin afectación', 'Operación parcial', 'Fuera de operación'].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (v) {},
                            decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                          ),
                        )),
                        DataCell(SizedBox(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: 'Vincular a iguala y servicio',
                                items: ['Vincular a iguala y servicio', 'Solo observación'].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                                onChanged: (v) {},
                                decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                              ),
                              Text('IG-00086 · OS-2026-00536', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                            ],
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
              SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: context.mutedTextColor, fontSize: 14),
                      children: [
                        TextSpan(text: '1', style: TextStyle(fontWeight: FontWeight.bold, color: context.textColor)),
                        TextSpan(text: ' solicitud(es) se crearán al guardar'),
                      ],
                    ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Origen: ', style: TextStyle(color: context.mutedTextColor, fontSize: 14)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
                        child: Text('IG-00086', style: TextStyle(color: AppColors.blue, fontSize: 14)),
                      ),
                      Text(' / ', style: TextStyle(color: context.mutedTextColor, fontSize: 14)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
                        child: Text('OS-2026-00536', style: TextStyle(color: AppColors.blue, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
