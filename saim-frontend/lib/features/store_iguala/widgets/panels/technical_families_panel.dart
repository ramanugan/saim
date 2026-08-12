import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/status_pill.dart';
import '../../../../core/theme/app_theme.dart';

class TechnicalFamiliesPanel extends StatelessWidget {
  TechnicalFamiliesPanel({super.key});

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
                  'Familias técnicas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Una iguala puede cubrir varias',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          
          // Families
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildFamilyCard(
                  context: context,
                  icon: Icons.ac_unit,
                  iconColor: Colors.blue.shade200,
                  iconBg: Colors.blue.shade50,
                  title: 'Refrigeración',
                  subtitle: 'Preventivos + atención correctiva',
                ),
                SizedBox(height: 16),
                _buildFamilyCard(
                  context: context,
                  icon: Icons.air,
                  iconColor: Colors.teal.shade300,
                  iconBg: Colors.teal.shade50,
                  title: 'Aire acondicionado',
                  subtitle: 'Preventivos + atención correctiva',
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add, size: 16),
                  label: Text('Agregar familia técnica'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.surfaceColor,
                    foregroundColor: AppColors.navy,
                    elevation: 0,
                    side: BorderSide(color: context.borderColor),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          StatusPill(text: 'Vigente', type: StatusType.success),
        ],
      ),
    );
  }
}
