import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';
import '../../../../services/task_service.dart';
import '../../../../view/pomodoro_screen.dart';
import '../../../../view/settings_screen.dart';
import 'widgets/task_card.dart';
import 'widgets/task_editor_sheet.dart';
import 'widgets/task_empty_view.dart';
import 'widgets/task_filter_bar.dart';
import 'widgets/task_search_bar.dart';

/// Main screen featuring the task list, priority filtering, and search functionality.
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

  void _navigateToPomodoro([TaskItem? task]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PomodoroScreen(task: task)),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
        actions: [
          IconButton(
            tooltip: loc.pomodoroTitle,
            icon: const Icon(Icons.timer_outlined),
            onPressed: () => _navigateToPomodoro(),
          ),
          IconButton(
            tooltip: loc.settings,
            icon: const Icon(Icons.settings_rounded),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => TaskEditorSheet.show(context),
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
            // Filter and Search Header
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
                  FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                      CurvedAnimation(
                        parent: _searchAnimationController,
                        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                      ),
                    ),
                    child: IgnorePointer(
                      ignoring: _isSearching,
                      child: TaskFilterBar(
                        selectedFilter: _selectedFilter,
                        onFilterSelected: (filter) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        onSearchPressed: _openSearch,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SizeTransition(
                      sizeFactor: _searchAnimation,
                      axis: Axis.horizontal,
                      alignment: AlignmentDirectional.centerStart,
                      child: TaskSearchBar(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        onClose: _closeSearch,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Task List View
            Expanded(
              child: ListenableBuilder(
                listenable: TaskService.instance,
                builder: (context, _) {
                  var tasks = TaskService.instance.getTasks(
                    filter: _selectedFilter,
                  );

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
                    return const TaskEmptyView();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 84,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () => TaskEditorSheet.show(
                          context,
                          taskToEdit: task,
                        ),
                        onPomodoroTap: () => _navigateToPomodoro(task),
                      );
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
}

