import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class DonutChartCard extends StatelessWidget {
  DonutChartCard({super.key});

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
                      'Órdenes documentales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Estado del expediente',
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
                child: Text('Ver todas'),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(140, 140),
                          painter: _DonutChartPainter(
                            segments: [
                              _Segment(96, AppColors.green),
                              _Segment(12, AppColors.blue),
                              _Segment(7, AppColors.amber),
                              _Segment(5, AppColors.red),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '74%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: context.textColor,
                                letterSpacing: -1,
                              ),
                            ),
                            Text(
                              'cerradas',
                              style: TextStyle(
                                fontSize: 13,
                                color: context.mutedTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(context, 'Validadas', '96', AppColors.green),
                    SizedBox(height: 12),
                    _buildLegendItem(context, 'En validación', '12', AppColors.blue),
                    SizedBox(height: 12),
                    _buildLegendItem(context, 'En captura', '7', AppColors.amber),
                    SizedBox(height: 12),
                    _buildLegendItem(context, 'Observadas', '5', AppColors.red),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: context.textColor,
          ),
        ),
      ],
    );
  }
}

class _Segment {
  final double value;
  final Color color;
  _Segment(this.value, this.color);
}

class _DonutChartPainter extends CustomPainter {
  final List<_Segment> segments;
  _DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = segments.fold(0, (sum, item) => sum + item.value);
    
    final Paint bgPaint = Paint()
      ..color = AppColors.blue50.withOpacity(0.1) // made slightly transparent for dark mode compat
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.butt;
      
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 12; // half stroke width
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background track
    canvas.drawCircle(center, radius, bgPaint);

    if (total == 0) return;

    // Draw segments
    double startAngle = -math.pi / 2; // Start from top
    
    for (var segment in segments) {
      final double sweepAngle = (segment.value / total) * 2 * math.pi;
      
      final Paint paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.butt;

      // Draw segment (with a tiny gap if we wanted, but standard donut is fine)
      canvas.drawArc(rect, startAngle, sweepAngle - 0.04, false, paint);
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
