import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/task_item.dart';
import '../services/locale_controller.dart';
import '../services/task_service.dart';
import 'pomodoro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'all';
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final AnimationController _searchAnimationController;
  late final Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 320),
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  void _openSearch() {
    setState(() {
      _isSearching = true;
    });
    _searchAnimationController.forward();
    _searchFocusNode.requestFocus();
  }

  void _closeSearch() {
    _searchFocusNode.unfocus();
    _searchAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchQuery = '';
          _searchController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xffe53935);
      case TaskPriority.medium:
        return const Color(0xfff57c00);
      case TaskPriority.low:
        return const Color(0xff43a047);
    }
  }

  String _getPriorityLabel(BuildContext context, TaskPriority priority) {
    final loc = AppLocalizations.of(context);
    switch (priority) {
      case TaskPriority.high:
        return loc.high;
      case TaskPriority.medium:
        return loc.medium;
      case TaskPriority.low:
        return loc.low;
    }
  }

  void _showTaskDialog({TaskItem? taskToEdit}) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final isEditing = taskToEdit != null;

    final titleController = TextEditingController(
      text: taskToEdit?.title ?? '',
    );
    var currentPriority = taskToEdit?.priority ?? TaskPriority.medium;
    var isDone = taskToEdit?.isCompleted ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Grab indicator
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: colors.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? loc.editTask : loc.addTask,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                        if (isEditing)
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                            tooltip: loc.delete,
                            onPressed: () async {
                              await TaskService.instance.deleteTask(
                                taskToEdit.id,
                              );
                              if (!ctx.mounted) return;
                              Navigator.pop(ctx);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Task title field
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: loc.taskTitle,
                        hintText: loc.taskTitleHint,
                        filled: true,
                        fillColor: colors.primary.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Priority selection
                    Text(
                      loc.priority,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: colors.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: TaskPriority.values.map((priority) {
                        final isSelected = currentPriority == priority;
                        final pColor = _getPriorityColor(priority);

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: InkWell(
                              onTap: () {
                                setModalState(() {
                                  currentPriority = priority;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? pColor
                                      : pColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: pColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  _getPriorityLabel(context, priority),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : colors.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),

                    // Completion status checkbox
                    CheckboxListTile(
                      value: isDone,
                      onChanged: (val) {
                        setModalState(() {
                          isDone = val ?? false;
                        });
                      },
                      activeColor: colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: colors.onSurface.withValues(alpha: 0.12),
                        ),
                      ),
                      title: Text(
                        loc.isCompleted,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(loc.cancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async {
                              final text = titleController.text.trim();
                              if (text.isEmpty) return;

                              if (isEditing) {
                                final updated = taskToEdit.copyWith(
                                  title: text,
                                  priority: currentPriority,
                                  isCompleted: isDone,
                                );
                                await TaskService.instance.updateTask(updated);
                              } else {
                                final newTask = TaskItem(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  title: text,
                                  priority: currentPriority,
                                  isCompleted: isDone,
                                );
                                await TaskService.instance.addTask(newTask);
                              }

                              if (!ctx.mounted) return;
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              loc.save,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: [
          // Pomodoro Timer Icon in AppBar
          IconButton(
            tooltip: loc.pomodoroTitle,
            icon: const Icon(Icons.timer_outlined),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const PomodoroScreen()));
            },
          ),

          // Language Globe Icon
          IconButton(
            tooltip: loc.switchLanguage,
            icon: const Icon(Icons.language_rounded),
            onPressed: () {
              LocaleController.instance.toggleLocale();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          loc.addTask,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter Bar and Expanding Search Bar
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: colors.onSurface.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Filter Bar with Search Button (fades out when searching)
                  FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                      CurvedAnimation(
                        parent: _searchAnimationController,
                        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                      ),
                    ),
                    child: IgnorePointer(
                      ignoring: _isSearching,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.search_rounded,
                              color: colors.primary,
                            ),
                            tooltip: loc.search,
                            onPressed: _openSearch,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip(
                                    id: 'all',
                                    label: loc.all,
                                    icon: Icons.filter_list_rounded,
                                    color: colors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(
                                    id: 'high',
                                    label: loc.high,
                                    icon: Icons.flag_rounded,
                                    color: const Color(0xffe53935),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(
                                    id: 'medium',
                                    label: loc.medium,
                                    icon: Icons.flag_rounded,
                                    color: const Color(0xfff57c00),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterChip(
                                    id: 'low',
                                    label: loc.low,
                                    icon: Icons.flag_outlined,
                                    color: const Color(0xff43a047),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Expanding Search Bar (visibly stretches/pulls open across the screen)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SizeTransition(
                      sizeFactor: _searchAnimation,
                      axis: Axis.horizontal,
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        height: 44,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.primary,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: colors.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                decoration: InputDecoration(
                                  hintText: loc.searchHint,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val.trim();
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              tooltip: loc.cancel,
                              onPressed: _closeSearch,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Task List
            Expanded(
              child: ListenableBuilder(
                listenable: TaskService.instance,
                builder: (context, _) {
                  var tasks = TaskService.instance.getTasks(
                    filter: _selectedFilter,
                  );

                  // Apply search query filter if searching
                  if (_searchQuery.isNotEmpty) {
                    tasks = tasks
                        .where(
                          (t) => t.title.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ),
                        )
                        .toList();
                  }

                  if (tasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 64,
                            color: colors.onSurface.withValues(alpha: 0.25),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            loc.noTasks,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            loc.emptyTasksHelp,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 84, // Space for FAB
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildTaskCard(task, colors);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String id,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedFilter == id;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = id;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : colors.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task, ColorScheme colors) {
    final loc = AppLocalizations.of(context);
    final pColor = _getPriorityColor(task.priority);
    final isDone = task.isCompleted;

    return Card(
      elevation: isDone ? 0.5 : 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDone
              ? colors.onSurface.withValues(alpha: 0.08)
              : colors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      color: isDone ? colors.surface.withValues(alpha: 0.6) : colors.surface,
      child: InkWell(
        onTap: () => _showTaskDialog(taskToEdit: task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Checkbox on the side
              Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: isDone,
                  activeColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (val) async {
                    await TaskService.instance.toggleTaskCompleted(task);
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Task Title
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isDone ? FontWeight.normal : FontWeight.w600,
                    color: isDone
                        ? colors.onSurface.withValues(alpha: 0.45)
                        : colors.onSurface,
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Priority Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isDone
                      ? colors.onSurface.withValues(alpha: 0.08)
                      : pColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDone
                        ? colors.onSurface.withValues(alpha: 0.15)
                        : pColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  _getPriorityLabel(context, task.priority),
                  style: TextStyle(
                    color: isDone
                        ? colors.onSurface.withValues(alpha: 0.5)
                        : pColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Pomodoro Timer Icon Button on the side of the task
              IconButton(
                icon: Icon(
                  Icons.timer_outlined,
                  color: colors.primary,
                  size: 22,
                ),
                tooltip: loc.pomodoroTitle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PomodoroScreen(task: task),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
