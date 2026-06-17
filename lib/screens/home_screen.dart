import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task_model.dart';
import '../services/task_storage_service.dart';
import '../widgets/glass_container.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/empty_state.dart';

enum TaskFilter { all, pending, completed }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TaskStorageService _storageService = TaskStorageService();
  List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  bool _isLoading = true;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _loadTasks();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storageService.loadTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
      _fabAnimationController.forward();
    }
  }

  Future<void> _saveTasks() async {
    await _storageService.saveTasks(_tasks);
  }

  List<Task> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.pending:
        return _tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.isCompleted).toList();
      case TaskFilter.all:
        return List.from(_tasks);
    }
  }

  Future<void> _addTask() async {
    HapticFeedback.lightImpact();
    final result = await showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (_) => const AddTaskSheet(title: 'Add New Task'),
    );
    if (result != null && result.isNotEmpty) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: result,
        createdAt: DateTime.now(),
      );
      setState(() => _tasks.insert(0, newTask));
      await _saveTasks();
      _showSnackBar('Task added!', Icons.check_circle_rounded, Colors.greenAccent);
    }
  }

  Future<void> _editTask(Task task) async {
    HapticFeedback.lightImpact();
    final result = await showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (_) => AddTaskSheet(title: 'Edit Task', initialValue: task.title),
    );
    if (result != null && result.isNotEmpty && result != task.title) {
      setState(() {
        final i = _tasks.indexWhere((t) => t.id == task.id);
        if (i != -1) _tasks[i] = task.copyWith(title: result);
      });
      await _saveTasks();
      _showSnackBar('Task updated!', Icons.edit_rounded, Colors.blueAccent);
    }
  }

  Future<void> _toggleTask(Task task) async {
    HapticFeedback.selectionClick();
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == task.id);
      if (i != -1) _tasks[i] = task.copyWith(isCompleted: !task.isCompleted);
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(Task task) async {
    HapticFeedback.mediumImpact();
    setState(() => _tasks.removeWhere((t) => t.id == task.id));
    await _saveTasks();
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: GlassContainer(
          borderRadius: 14,
          tintColor: Colors.red,
          opacity: 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.delete_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '"${task.title}" deleted',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() => _tasks.insert(0, task));
                  _saveTasks();
                },
                child: const Text(
                  'UNDO',
                  style: TextStyle(
                      color: Colors.amberAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _clearCompleted() async {
    final count = _tasks.where((t) => t.isCompleted).length;
    if (count == 0) return;
    HapticFeedback.mediumImpact();
    setState(() => _tasks.removeWhere((t) => t.isCompleted));
    await _saveTasks();
    _showSnackBar(
      '$count task${count > 1 ? 's' : ''} cleared!',
      Icons.cleaning_services_rounded,
      Colors.orangeAccent,
    );
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: GlassContainer(
          borderRadius: 14,
          tintColor: color,
          opacity: 0.25,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Text(message,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String get _filterLabel {
    switch (_currentFilter) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.completed:
        return 'Completed';
    }
  }

  int get _pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning ☀️';
    if (h < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: GlassContainer(
          borderRadius: 20,
          tintColor: const Color(0xFF7C3AED),
          opacity: 0.7,
          border: Border.all(
            color: const Color(0xFFa78bfa).withValues(alpha: 0.6),
            width: 1.5,
          ),
          child: FloatingActionButton.extended(
            onPressed: _addTask,
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            label: const Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'My Tasks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      if (_completedCount > 0)
                        GestureDetector(
                          onTap: _clearCompleted,
                          child: GlassContainer(
                            borderRadius: 12,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.cleaning_services_rounded,
                                    color: Colors.orangeAccent.shade100,
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  'Clear done',
                                  style: TextStyle(
                                    color: Colors.orangeAccent.shade100,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Stats
                  Row(
                    children: [
                      _StatChip(label: 'Total', count: _tasks.length, color: Colors.white),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Pending', count: _pendingCount, color: Colors.amberAccent),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Done', count: _completedCount, color: Colors.greenAccent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress bar
                  if (_tasks.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progress',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12)),
                        Text(
                          '${(_completedCount / _tasks.length * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 8,
                        color: Colors.white.withValues(alpha: 0.12),
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final progress = _completedCount / _tasks.length;
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                width: constraints.maxWidth * progress,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFF7C3AED),
                                    Colors.greenAccent
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Filter tabs
                  GlassContainer(
                    borderRadius: 14,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: TaskFilter.values.map((filter) {
                        final isSelected = _currentFilter == filter;
                        final label = filter == TaskFilter.all
                            ? 'All'
                            : filter == TaskFilter.pending
                                ? 'Pending'
                                : 'Completed';
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _currentFilter = filter);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7C3AED).withValues(alpha: 0.7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFFa78bfa)
                                            .withValues(alpha: 0.5),
                                        width: 1)
                                    : null,
                              ),
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Task list
            Expanded(
              child: filtered.isEmpty
                  ? EmptyState(filterLabel: _filterLabel)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final task = filtered[index];
                        return TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onDelete: () => _deleteTask(task),
                          onEdit: () => _editTask(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
        ],
      ),
    );
  }
}