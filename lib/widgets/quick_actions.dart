import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(child: _buildQuickAction(context, 'Work Task', 'Work', Icons.work, Colors.blue)),
          const SizedBox(width: 12),
          Expanded(child: _buildQuickAction(context, 'Personal', 'Personal', Icons.person, Colors.teal)),
          const SizedBox(width: 12),
          Expanded(child: _buildQuickAction(context, 'Health', 'Health', Icons.favorite, Colors.green)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, String category, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _createQuickTask(context, category),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _createQuickTask(BuildContext context, String category) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Quick ${category.toLowerCase()} task',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now(),
      category: category,
    );
    taskProvider.addTask(task);
  }
}