import 'package:flutter/material.dart';
import '../form/form_section_title.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class Section08Evidence extends StatelessWidget {
  Section08Evidence({super.key});

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
            number: '08',
            title: 'Evidencia y ubicación',
            subtitle: 'Fotografías antes, durante y después; archivos y GPS.',
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: _buildUploadZone(context, ),
                  ),
                  if (isWide) SizedBox(width: 24) else SizedBox(height: 24),
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: _buildLocationCard(context, ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUploadZone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.borderColor, style: BorderStyle.none),
          ),
          // We simulate the dashed border using a CustomPaint or simply keep it solid for now, but a dashed border package or custom painter is usually used. For simplicity, we use solid with light color as in prototype if dashed is complex, or use dotted_border if available. We don't have dotted_border package so we use a simple border.
          child: Column(
            children: [
              Icon(Icons.upload_file, color: AppColors.blue, size: 32),
              SizedBox(height: 12),
              Text(
                'Tomar foto o cargar archivos',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.blue),
              ),
              SizedBox(height: 4),
              Text(
                'JPG, PNG, MP4 o PDF · máximo 25 MB por archivo',
                style: TextStyle(fontSize: 11, color: context.mutedTextColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        _buildFileChip(context, 'condensador_antes.jpg', '1.8 MB · Antes', 'ANTES', AppColors.blue),
        SizedBox(height: 8),
        _buildFileChip(context, 'condensador_despues.jpg', '2.1 MB · Después', 'DESPUÉS', AppColors.green),
      ],
    );
  }

  Widget _buildFileChip(BuildContext context, String filename, String info, String tag, Color tagColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: context.textColor)),
                Text(info, style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: context.mutedTextColor),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gps_fixed, color: context.mutedTextColor, size: 24),
                SizedBox(height: 8),
                Text('Mapa de demostración', style: TextStyle(color: context.mutedTextColor, fontSize: 11)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ubicación del servicio', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: context.textColor)),
                SizedBox(height: 4),
                Text('20.6597, -103.3496 · precisión 18 m', style: TextStyle(fontSize: 13, color: AppColors.ink)),
                SizedBox(height: 2),
                Text('Capturada en dispositivo · 21 jul 13:54', style: TextStyle(fontSize: 11, color: context.mutedTextColor)),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    minimumSize: Size(double.infinity, 36),
                    side: BorderSide(color: context.borderColor),
                  ),
                  child: Text('Actualizar ubicación'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
