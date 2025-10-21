import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class TaskItem {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final String priority;
  final IconData icon;
  final Color color;

  const TaskItem({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.priority = 'medium',
    this.icon = Icons.task_alt,
    this.color = Constants.kPrimaryColor,
  });
}

class DailyTasksWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<TaskItem> tasks;
  final Function(int)? onTaskToggle;
  final VoidCallback? onViewAll;

  const DailyTasksWidget({
    super.key,
    this.title = 'Tarefas Diárias',
    this.subtitle = 'Hoje',
    this.tasks = const [
      TaskItem(
        title: 'Verificar irrigação',
        subtitle: 'Setor A - 09:00',
        isCompleted: true,
        priority: 'high',
        icon: Icons.water_drop,
        color: Color(0xFF06B6D4),
      ),
      TaskItem(
        title: 'Aplicar fertilizante',
        subtitle: 'Setor B - 14:00',
        isCompleted: false,
        priority: 'high',
        icon: Icons.eco,
        color: Color(0xFF059669),
      ),
      TaskItem(
        title: 'Coleta de dados',
        subtitle: 'Laboratório - 16:00',
        isCompleted: false,
        priority: 'medium',
        icon: Icons.analytics,
        color: Color(0xFF8B5CF6),
      ),
      TaskItem(
        title: 'Relatório semanal',
        subtitle: 'Escritório - 18:00',
        isCompleted: false,
        priority: 'low',
        icon: Icons.description,
        color: Color(0xFF6366F1),
      ),
      TaskItem(
        title: 'Manutenção equipamentos',
        subtitle: 'Setor C - 10:30',
        isCompleted: true,
        priority: 'medium',
        icon: Icons.build,
        color: Color(0xFFEA580C),
      ),
      TaskItem(
        title: 'Verificar pH da água',
        subtitle: 'Reservatório - 13:00',
        isCompleted: false,
        priority: 'high',
        icon: Icons.science,
        color: Color(0xFFDC2626),
      ),
      TaskItem(
        title: 'Monitorar temperatura',
        subtitle: 'Estufa - 15:30',
        isCompleted: false,
        priority: 'medium',
        icon: Icons.thermostat,
        color: Color(0xFF7C3AED),
      ),
      TaskItem(
        title: 'Preparar solução nutritiva',
        subtitle: 'Laboratório - 17:00',
        isCompleted: false,
        priority: 'high',
        icon: Icons.local_drink,
        color: Color(0xFF10B981),
      ),
    ],
    this.onTaskToggle,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isVerySmallScreen = constraints.maxWidth < 400;

        // Calcula dimensões responsivas
        final horizontalPadding = constraints.maxWidth * 0.05;
        final internalPadding =
            isVerySmallScreen ? 16.0 : (isSmallScreen ? 20.0 : 24.0);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            height: constraints.maxHeight, // Usa toda altura disponível
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(internalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isSmallScreen, isVerySmallScreen),
                  SizedBox(height: isVerySmallScreen ? 12 : 16),
                  Expanded(
                      child: _buildTasksList(isSmallScreen, isVerySmallScreen)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalTasks = tasks.length;
    final completionPercentage =
        totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 18 : (isSmallScreen ? 20 : 22),
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isVerySmallScreen ? 2 : 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 12 : 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isVerySmallScreen ? 8 : 12,
                vertical: isVerySmallScreen ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: _getCompletionColor(completionPercentage)
                    .withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: _getCompletionColor(completionPercentage),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$completedTasks/$totalTasks',
                    style: TextStyle(
                      color: _getCompletionColor(completionPercentage),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$completionPercentage% completo',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTasksList(
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    return Column(
      children: [
        // Lista com scroll vertical
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (context, index) => SizedBox(
              height: isVerySmallScreen ? 8 : 12,
            ),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItem(
                  task, index, isSmallScreen, isVerySmallScreen);
            },
          ),
        ),

        // Botão "Ver todas" fixo na parte inferior
        SizedBox(height: isVerySmallScreen ? 12 : 16),
        _buildViewAllButton(isSmallScreen, isVerySmallScreen),
      ],
    );
  }

  Widget _buildTaskItem(TaskItem task, int index,
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    return GestureDetector(
      onTap: () => onTaskToggle?.call(index),
      child: Container(
        padding: EdgeInsets.all(isVerySmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: task.isCompleted ? Colors.grey[50] : Colors.white,
          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
          border: Border.all(
            color: task.isCompleted ? Colors.grey[200]! : Colors.grey[100]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox/Icon
            Container(
              width: isVerySmallScreen ? 36 : 40,
              height: isVerySmallScreen ? 36 : 40,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? task.color
                    : task.color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
              ),
              child: Icon(
                task.isCompleted ? Icons.check : task.icon,
                color: task.isCompleted ? Colors.white : task.color,
                size: isVerySmallScreen ? 16 : 20,
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 8 : 12),

            // Task content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color:
                          task.isCompleted ? Colors.grey[500] : Colors.black87,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isVerySmallScreen ? 1 : 2),
                  Text(
                    task.subtitle,
                    style: TextStyle(
                      fontSize: isVerySmallScreen ? 10 : 12,
                      color: task.isCompleted
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Priority indicator
            Container(
              width: isVerySmallScreen ? 6 : 8,
              height: isVerySmallScreen ? 6 : 8,
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton(
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isVerySmallScreen ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
          border: Border.all(
            color: Constants.kPrimaryColor.withValues(alpha: .2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ver todas as tarefas',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: isVerySmallScreen ? 12 : 14,
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 2 : 4),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.kPrimaryColor,
              size: isVerySmallScreen ? 10 : 12,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor(int percentage) {
    if (percentage >= 80) return Colors.green[600]!;
    if (percentage >= 50) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red[500]!;
      case 'medium':
        return Colors.orange[500]!;
      case 'low':
        return Colors.green[500]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
