import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class DocumentViewer extends StatelessWidget {
  DocumentViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              color: context.backgroundColor,
              border: Border.all(color: context.borderColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(Icons.image, size: 40, color: context.mutedTextColor),
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documento original',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'orden_pachuca_200726.jpg',
                  style: TextStyle(
                    color: context.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Orden en papel firmada por el técnico y la jefa de mantenimiento. Se conserva sin sobrescribir.',
                  style: TextStyle(color: context.mutedTextColor, fontSize: 14),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildTag(context, '2.7 MB'),
                    SizedBox(width: 8),
                    _buildTag(context, 'Recibida por WhatsApp'),
                    SizedBox(width: 8),
                    _buildTag(context, 'Hash 8e7b...c41a'),
                    SizedBox(width: 8),
                    _buildTag(context, 'Original vigente'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Recibió', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
              SizedBox(height: 4),
              Text('María López', style: TextStyle(color: context.textColor, fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('21 jul 2026 · 17:32', style: TextStyle(color: context.mutedTextColor, fontSize: 12)),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: BorderSide(color: context.borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text('Adjuntar otro original'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
