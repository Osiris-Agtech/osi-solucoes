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
    Key? key,
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
    ],
    this.onTaskToggle,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildTasksList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalTasks = tasks.length;
    final completionPercentage =
        totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color:
                    _getCompletionColor(completionPercentage).withOpacity(0.1),
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

  Widget _buildTasksList() {
    return Column(
      children: [
        ...tasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          final isLast = index == tasks.length - 1;

          return Column(
            children: [
              _buildTaskItem(task, index),
              if (!isLast) const SizedBox(height: 12),
            ],
          );
        }).toList(),
        const SizedBox(height: 16),
        _buildViewAllButton(),
      ],
    );
  }

  Widget _buildTaskItem(TaskItem task, int index) {
    return GestureDetector(
      onTap: () => onTaskToggle?.call(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: task.isCompleted ? Colors.grey[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: task.isCompleted ? Colors.grey[200]! : Colors.grey[100]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox/Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    task.isCompleted ? task.color : task.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                task.isCompleted ? Icons.check : task.icon,
                color: task.isCompleted ? Colors.white : task.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Task content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          task.isCompleted ? Colors.grey[500] : Colors.black87,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isCompleted
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Priority indicator
            Container(
              width: 8,
              height: 8,
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

  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Constants.kPrimaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Ver todas as tarefas',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.kPrimaryColor,
              size: 12,
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
