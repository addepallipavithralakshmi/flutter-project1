import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/subtask.dart';

class TaskProvider extends ChangeNotifier {
  Box<Task>? _taskBox;
  Box? _settingsBox;
  List<Task> _tasks = [];
  bool _isDarkMode = false;
  int _streakCount = 0;
  DateTime? _lastCompletionDate;

  List<Task> get tasks => _tasks;
  bool get isDarkMode => _isDarkMode;
  int get streakCount => _streakCount;

  List<Task> get todayTasks {
    final today = DateTime.now();
    return _tasks.where((task) => 
      !task.isCompleted && 
      task.dueDate.day == today.day &&
      task.dueDate.month == today.month &&
      task.dueDate.year == today.year
    ).toList();
  }

  List<Task> get upcomingTasks {
    final today = DateTime.now();
    return _tasks.where((task) => 
      !task.isCompleted && task.dueDate.isAfter(today)
    ).toList();
  }

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  List<Task> get overdueTasks {
    final now = DateTime.now();
    return _tasks.where((task) => 
      !task.isCompleted && task.dueDate.isBefore(DateTime(now.year, now.month, now.day))
    ).toList();
  }

  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return completedTasks.length / _tasks.length;
  }

  Map<Priority, int> get priorityStats {
    return {
      Priority.high: _tasks.where((t) => t.priority == Priority.high && !t.isCompleted).length,
      Priority.medium: _tasks.where((t) => t.priority == Priority.medium && !t.isCompleted).length,
      Priority.low: _tasks.where((t) => t.priority == Priority.low && !t.isCompleted).length,
    };
  }

  List<Task> get todayCompletedTasks {
    final today = DateTime.now();
    return _tasks.where((task) => 
      task.isCompleted && 
      task.createdAt.day == today.day &&
      task.createdAt.month == today.month &&
      task.createdAt.year == today.year
    ).toList();
  }

  double get todayProductivity {
    final todayTasks = _tasks.where((task) => 
      task.dueDate.day == DateTime.now().day &&
      task.dueDate.month == DateTime.now().month &&
      task.dueDate.year == DateTime.now().year
    ).toList();
    if (todayTasks.isEmpty) return 0.0;
    final completed = todayTasks.where((t) => t.isCompleted).length;
    return completed / todayTasks.length;
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(PriorityAdapter());
    Hive.registerAdapter(SubtaskAdapter());
    _taskBox = await Hive.openBox<Task>('tasks');
    _settingsBox = await Hive.openBox('settings');
    _loadSettings();
    _loadTasks();
  }

  void _loadSettings() {
    _isDarkMode = _settingsBox?.get('darkMode', defaultValue: false) ?? false;
    _streakCount = _settingsBox?.get('streakCount', defaultValue: 0) ?? 0;
    final lastDateString = _settingsBox?.get('lastCompletionDate');
    if (lastDateString != null) {
      _lastCompletionDate = DateTime.parse(lastDateString);
    }
  }

  void _loadTasks() {
    _tasks = _taskBox?.values.toList() ?? [];
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskBox?.put(task.id, task);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskBox?.put(task.id, task);
    _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskBox?.delete(id);
    _loadTasks();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = _taskBox?.get(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        _updateStreak();
      }
      await _taskBox?.put(id, task);
      _loadTasks();
    }
  }

  void _updateStreak() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    if (_lastCompletionDate == null) {
      _streakCount = 1;
    } else {
      final lastDate = DateTime(_lastCompletionDate!.year, _lastCompletionDate!.month, _lastCompletionDate!.day);
      final daysDifference = todayDate.difference(lastDate).inDays;
      
      if (daysDifference == 1) {
        _streakCount++;
      } else if (daysDifference > 1) {
        _streakCount = 1;
      }
    }
    
    _lastCompletionDate = today;
    _settingsBox?.put('streakCount', _streakCount);
    _settingsBox?.put('lastCompletionDate', today.toIso8601String());
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _settingsBox?.put('darkMode', _isDarkMode);
    notifyListeners();
  }

  List<Task> searchTasks(String query) {
    return _tasks.where((task) => 
      task.title.toLowerCase().contains(query.toLowerCase()) ||
      task.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}