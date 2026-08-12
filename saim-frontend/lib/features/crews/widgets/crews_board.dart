import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/crew_data.dart';
import '../../../core/theme/app_theme.dart';

class CrewsBoard extends StatelessWidget {
  CrewsBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // En pantallas pequeñas, hacer un layout vertical o un scroll horizontal.
        // Aquí asumiremos que el padre (SingleChildScrollView horizontal) permitirá el overflow, o podemos forzar un Row
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildColumn(context, 
                title: 'Sin asignar',
                count: '3',
                children: CrewData.unassigned.map((p) => _buildPersonCard(context, p)).toList(),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: _buildColumn(context, 
                title: 'Asignadas',
                count: '5',
                children: CrewData.assigned.map((c) => _buildCrewCard(context, c)).toList(),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: _buildColumn(context, 
                title: 'En ejecución',
                count: '2',
                children: CrewData.executing.map((c) => _buildCrewCard(context, c)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn(BuildContext context, {
    required String title,
    required String count,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.borderColor),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.mutedTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children.map((child) => Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: child,
              )),
        ],
      ),
    );
  }

  Widget _buildPersonCard(BuildContext context, CrewPerson person) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.blue50,
                child: Text(
                  person.initials,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    Text(
                      person.role,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: person.skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: context.borderColor),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 10,
                    color: context.mutedTextColor,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          Text(
            person.availability,
            style: TextStyle(
              fontSize: 11,
              color: context.mutedTextColor,
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: context.surfaceColor,
              foregroundColor: AppColors.navy,
              elevation: 0,
              side: BorderSide(color: context.borderColor),
              minimumSize: Size(double.infinity, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            child: Text('Asignar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCrewCard(BuildContext context, AssignedCrew crew) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: crew.isConflict ? AppColors.red : AppColors.line,
          width: crew.isConflict ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 48,
                height: 32,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.blue50,
                        child: Text(
                          crew.initials[0],
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: context.surfaceColor,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.blue50,
                          child: Text(
                            crew.initials.length > 1 ? crew.initials[1] : '',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crew.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                    ),
                    Text(
                      crew.role,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crew.task,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  crew.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          if (crew.isExecuting && crew.progress != null) ...[
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: crew.progress,
                minHeight: 4,
                backgroundColor: AppColors.line,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
              ),
            ),
          ],
          if (crew.status.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              crew.status,
              style: TextStyle(
                fontSize: 11,
                color: crew.isConflict ? AppColors.red : AppColors.muted,
              ),
            ),
          ],
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: crew.isConflict ? AppColors.red50 : context.surfaceColor,
              foregroundColor: crew.isConflict ? AppColors.red : AppColors.navy,
              elevation: 0,
              side: BorderSide(
                color: crew.isConflict ? Colors.transparent : AppColors.line,
              ),
              minimumSize: Size(double.infinity, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            child: Text(crew.actionText),
          ),
        ],
      ),
    );
  }
}
