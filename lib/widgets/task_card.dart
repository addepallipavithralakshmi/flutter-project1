import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'add_task_sheet.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color _getPriorityColor(Priority priority, BuildContext context) {
    switch (priority) {
      case Priority.high:
        return Colors.red.shade400;
      case Priority.medium:
        return Colors.orange.shade400;
      case Priority.low:
        return Colors.green.shade400;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue.shade600;
      case 'Health':
        return Colors.green.shade600;
      case 'Learning':
        return Colors.purple.shade600;
      case 'Shopping':
        return Colors.pink.shade600;
      case 'Personal':
        return Colors.teal.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  bool get _isOverdue {
    final now = DateTime.now();
    return !task.isCompleted && task.dueDate.isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    
    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          taskProvider.toggleTaskCompletion(task.id);
        } else {
          taskProvider.deleteTask(task.id);
        }
      },
      child: GestureDetector(
        onTap: () => _showEditTaskSheet(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: task.isCompleted 
                ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: _isOverdue 
                  ? Colors.red.withOpacity(0.6)
                  : _getPriorityColor(task.priority, context).withOpacity(0.3),
              width: _isOverdue ? 3 : 2,
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => taskProvider.toggleTaskCompletion(task.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isCompleted 
                        ? _getPriorityColor(task.priority, context)
                        : Colors.transparent,
                    border: Border.all(
                      color: _getPriorityColor(task.priority, context),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted
                            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                            : Theme.of(context).colorScheme.onSurface,
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: task.isCompleted
                              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(task.dueDate),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _isOverdue 
                                ? Colors.red 
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontWeight: _isOverdue ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        if (_isOverdue) ...[  
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'OVERDUE',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(task.category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.category.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: _getCategoryColor(task.category),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority, context).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.priority.name.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getPriorityColor(task.priority, context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (task.subtasks.isNotEmpty) ...[  
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: task.completionProgress,
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(
                          _getPriorityColor(task.priority, context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${task.subtasks.where((s) => s.isCompleted).length}/${task.subtasks.length} subtasks completed',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(task: task),
    );
  }
}