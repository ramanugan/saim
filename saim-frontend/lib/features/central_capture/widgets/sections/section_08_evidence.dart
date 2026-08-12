import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../field_order/widgets/form/form_section_title.dart';
import '../../../../core/theme/app_theme.dart';

class Section08Evidence extends StatelessWidget {
  Section08Evidence({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionTitle(
          number: '08',
          title: 'Evidencia y ubicación',
          subtitle: 'Fotografías antes, durante y después; archivos y GPS.',
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.borderColor, style: BorderStyle.solid), // It would be dashed in a real implementation
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.upload_file, color: context.mutedTextColor, size: 32),
                          SizedBox(height: 8),
                          Text('Tomar foto o cargar archivos', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('JPG, PNG, MP4 o PDF · máximo 25 MB por archivo', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildFileChip(context, 'ORIGINAL', 'orden_pachuca_200726.jpg', '2.7 MB · Documento original firmado', AppColors.amber),
                    SizedBox(height: 8),
                    _buildFileChip(context, 'DESPUÉS', 'rack_despues.jpg', '1.9 MB · Evidencia enviada por técnico', AppColors.blue),
                  ],
                ),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, color: context.mutedTextColor, size: 32),
                            SizedBox(height: 8),
                            Text('Referencia de tienda / reporte', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Ubicación del servicio', style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('20.09110, -98.75910 · transcrita del reporte del técnico', style: TextStyle(color: context.textColor, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('No corresponde a la oficina · referencia de la tienda y evidencia recibida', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFileChip(BuildContext context, String tag, String filename, String details, Color tagColor) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: tagColor),
            ),
            child: Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: TextStyle(color: context.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(details, style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: context.mutedTextColor, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
