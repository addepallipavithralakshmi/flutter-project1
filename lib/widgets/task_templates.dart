import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/subtask.dart';

class TaskTemplates extends StatelessWidget {
  const TaskTemplates({super.key});

  final Map<String, Map<String, dynamic>> templates = const {
    'Morning Routine': {
      'category': 'Health',
      'subtasks': ['Wake up early', 'Exercise', 'Healthy breakfast', 'Plan the day'],
      'priority': Priority.medium,
    },
    'Work Project': {
      'category': 'Work',
      'subtasks': ['Research', 'Create outline', 'First draft', 'Review & edit'],
      'priority': Priority.high,
    },
    'Learning Goal': {
      'category': 'Learning',
      'subtasks': ['Find resources', 'Study basics', 'Practice', 'Test knowledge'],
      'priority': Priority.medium,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Templates',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 74,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final templateName = templates.keys.elementAt(index);
                return _buildTemplate(context, templateName);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplate(BuildContext context, String templateName) {
    return GestureDetector(
      onTap: () => _createFromTemplate(context, templateName),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              templateName,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _createFromTemplate(BuildContext context, String templateName) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final template = templates[templateName]!;
    
    final subtasks = (template['subtasks'] as List<String>)
        .map((title) => Subtask(
              id: DateTime.now().millisecondsSinceEpoch.toString() + title.hashCode.toString(),
              title: title,
            ))
        .toList();

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: templateName,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now(),
      category: template['category'],
      priority: template['priority'],
      subtasks: subtasks,
    );
    
    taskProvider.addTask(task);
  }
}