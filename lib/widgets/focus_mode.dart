import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class FocusMode extends StatefulWidget {
  const FocusMode({super.key});

  @override
  State<FocusMode> createState() => _FocusModeState();
}

class _FocusModeState extends State<FocusMode> with TickerProviderStateMixin {
  late AnimationController _timerController;
  int _focusMinutes = 25;
  bool _isRunning = false;
  Task? _currentTask;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: Duration(minutes: _focusMinutes),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Mode', style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildTaskSelector(),
              const SizedBox(height: 32),
              _buildTimer(),
              const SizedBox(height: 32),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSelector() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final incompleteTasks = taskProvider.tasks.where((t) => !t.isCompleted).toList();
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Task to Focus On',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Task>(
                value: _currentTask,
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text('Choose a task...', style: GoogleFonts.poppins()),
                items: incompleteTasks.map((task) {
                  return DropdownMenuItem(
                    value: task,
                    child: Text(task.title, style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (task) => setState(() => _currentTask = task),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimer() {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _timerController,
            builder: (context, child) {
              return CircularProgressIndicator(
                value: _timerController.value,
                strokeWidth: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _timerController,
                builder: (context, child) {
                  final remaining = Duration(minutes: _focusMinutes) * (1 - _timerController.value);
                  return Text(
                    '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              Text(
                'Focus Time',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTimeButton(15),
            _buildTimeButton(25),
            _buildTimeButton(45),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _currentTask != null ? _toggleTimer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            _isRunning ? 'Pause' : 'Start Focus',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton(int minutes) {
    final isSelected = _focusMinutes == minutes;
    return GestureDetector(
      onTap: () => setState(() => _focusMinutes = minutes),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Text(
          '${minutes}m',
          style: GoogleFonts.poppins(
            color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timerController.stop();
    } else {
      _timerController.duration = Duration(minutes: _focusMinutes);
      _timerController.forward();
    }
    setState(() => _isRunning = !_isRunning);
  }
}