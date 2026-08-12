import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../core/theme/app_theme.dart';

class ValidationQueue extends StatelessWidget {
  ValidationQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
        boxShadow: AppColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cola de revisión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '12 órdenes pendientes',
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
          Divider(height: 1, color: context.borderColor),
          // Search box
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar folio o tienda',
                prefixIcon: Icon(Icons.search, color: context.mutedTextColor, size: 20),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: context.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: AppColors.blue),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          // List Items
          _buildQueueItem(context, 
            id: 'OS-2026-00536',
            subtitle: 'Pachuca · IG-00086',
            meta: 'Captura central · hace 18 min',
            status: StatusType.warning,
            statusLabel: 'Prioridad',
            isActive: true,
          ),
          _buildQueueItem(context, 
            id: 'OS-2026-00534',
            subtitle: 'Río Nilo · IG-00028',
            meta: 'Campo · hace 42 min',
            status: StatusType.info,
            statusLabel: 'Normal',
            isActive: false,
          ),
          _buildQueueItem(context, 
            id: 'OS-2026-00531',
            subtitle: 'Malecón · IG-00030',
            meta: 'Campo · hace 1 h',
            status: StatusType.info,
            statusLabel: 'Normal',
            isActive: false,
          ),
          _buildQueueItem(context, 
            id: 'OS-2026-00522',
            subtitle: 'Satélite · IG-00078',
            meta: 'Correctivo · hace 3 h',
            status: StatusType.danger,
            statusLabel: 'Crítico',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(BuildContext context, {
    required String id,
    required String subtitle,
    required String meta,
    required StatusType status,
    required String statusLabel,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue50 : context.surfaceColor,
          border: Border(
            bottom: BorderSide(color: context.borderColor),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  meta,
                  style: TextStyle(
                    color: context.mutedTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            StatusPill(
              text: statusLabel,
              type: status,
            ),
          ],
        ),
      ),
    );
  }
}
