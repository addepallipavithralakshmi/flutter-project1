import 'package:hive/hive.dart';
import 'subtask.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  Priority priority;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String category;

  @HiveField(8)
  List<Subtask> subtasks;

  @HiveField(9)
  DateTime? reminderTime;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
    required this.createdAt,
    this.category = 'Personal',
    this.subtasks = const [],
    this.reminderTime,
  });

  double get completionProgress {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    final completed = subtasks.where((s) => s.isCompleted).length;
    return completed / subtasks.length;
  }
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

class TaskCategories {
  static const List<String> categories = [
    'Personal',
    'Work',
    'Health',
    'Learning',
    'Shopping',
    'Other',
  ];
}