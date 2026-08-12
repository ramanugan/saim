import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class FunnelChartCard extends StatelessWidget {
  FunnelChartCard({super.key});

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
                      'Embudo de correctivos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Valor por etapa',
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
                child: Text('Detalle'),
              ),
            ],
          ),
          SizedBox(height: 32),
          // Funnel representation
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFunnelStage(context, 'Solicitado', '\$1.24 M', 1.0, constraints.maxWidth),
                    SizedBox(height: 7),
                    _buildFunnelStage(context, 'Cotizado', '\$980 mil', 0.87, constraints.maxWidth),
                    SizedBox(height: 7),
                    _buildFunnelStage(context, 'Autorizado', '\$712 mil', 0.69, constraints.maxWidth),
                    SizedBox(height: 7),
                    _buildFunnelStage(context, 'Terminado', '\$480 mil', 0.52, constraints.maxWidth),
                    SizedBox(height: 7),
                    _buildFunnelStage(context, 'Cobrado', '\$305 mil', 0.38, constraints.maxWidth),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFunnelStage(BuildContext context, String label, String value, double widthRatio, double totalWidth) {
    return Center(
      child: ClipPath(
        clipper: _FunnelClipper(),
        child: Container(
          width: totalWidth * widthRatio,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD9EAF7), Color(0xFFA8C8E6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: (totalWidth * widthRatio) - 36 > 0 ? (totalWidth * widthRatio) - 36 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.textColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FunnelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // polygon(5% 0,95% 0,100% 100%,0 100%)
    final path = Path();
    path.moveTo(size.width * 0.05, 0);
    path.lineTo(size.width * 0.95, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
