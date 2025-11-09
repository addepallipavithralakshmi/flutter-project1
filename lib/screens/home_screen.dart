import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/motivational_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/streak_notification.dart';
import '../widgets/quick_actions.dart';
import '../widgets/task_templates.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAddTaskSheet() {
    _fabController.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskSheet(),
    ).then((_) => _fabController.reverse());
  }

  void _onSearchChanged(String query) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _filteredTasks = [];
      } else {
        _isSearching = true;
        _filteredTasks = taskProvider.searchTasks(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _isSearching ? _buildSearchResults() : _buildTaskSections(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _fabController.value * 0.5,
            child: FloatingActionButton(
              onPressed: _showAddTaskSheet,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello! 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Let\'s organize your day',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${(taskProvider.completionPercentage * 100).toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'Complete',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${taskProvider.streakCount}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          'Streak 🔥',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
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
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
            hintStyle: GoogleFonts.poppins(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredTasks.isEmpty) {
      return const Center(
        child: Text('No tasks found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: TaskCard(task: _filteredTasks[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskSections() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.tasks.isEmpty) {
          return const EmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MotivationalCard(),
              const SizedBox(height: 16),
              StreakNotification(streakCount: taskProvider.streakCount),
              const QuickActions(),
              const TaskTemplates(),
              if (taskProvider.overdueTasks.isNotEmpty) ...[  
                _buildSectionHeader('⚠️ Overdue', taskProvider.overdueTasks.length),
                const SizedBox(height: 16),
                ...taskProvider.overdueTasks.asMap().entries.map((entry) {
                  return AnimationConfiguration.staggeredList(
                    position: entry.key,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: TaskCard(task: entry.value),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
              if (taskProvider.todayTasks.isNotEmpty) ...[
                _buildSectionHeader('🕓 Today', taskProvider.todayTasks.length),
                const SizedBox(height: 16),
                ...taskProvider.todayTasks.asMap().entries.map((entry) {
                  return AnimationConfiguration.staggeredList(
                    position: entry.key,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: TaskCard(task: entry.value),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
              if (taskProvider.upcomingTasks.isNotEmpty) ...[
                _buildSectionHeader('📅 Upcoming', taskProvider.upcomingTasks.length),
                const SizedBox(height: 16),
                ...taskProvider.upcomingTasks.asMap().entries.map((entry) {
                  return AnimationConfiguration.staggeredList(
                    position: entry.key,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: TaskCard(task: entry.value),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
              if (taskProvider.completedTasks.isNotEmpty) ...[
                _buildSectionHeader('✅ Completed', taskProvider.completedTasks.length),
                const SizedBox(height: 16),
                ...taskProvider.completedTasks.asMap().entries.map((entry) {
                  return AnimationConfiguration.staggeredList(
                    position: entry.key,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: TaskCard(task: entry.value),
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}