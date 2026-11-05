import 'package:flutter/material.dart';

import '../../../../core/extensions/task_priority_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';
import '../../../../services/task_service.dart';

/// Interactive task list item supporting swipe-to-delete, completion toggle,
/// priority badge, and quick Pomodoro launcher.
class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  final VoidCallback onPomodoroTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onPomodoroTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final pColor = task.priority.color;
    final isDone = task.isCompleted;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(AlignmentDirectional.centerStart),
      secondaryBackground:
          _buildSwipeBackground(AlignmentDirectional.centerEnd),
      confirmDismiss: (_) async => true,
      onDismissed: (_) async {
        await TaskService.instance.deleteTask(task.id);
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.taskDeleted),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: loc.undo,
              onPressed: () async {
                await TaskService.instance.restoreTask(task);
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      },
      child: Card(
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Completion Checkbox
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: isDone,
                    activeColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (_) async {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
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
                    task.priority.label(context),
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

                // Pomodoro Timer Button
                IconButton(
                  icon: Icon(
                    Icons.timer_outlined,
                    color: colors.primary,
                    size: 22,
                  ),
                  tooltip: loc.pomodoroTitle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 34,
                    minHeight: 34,
                  ),
                  onPressed: onPomodoroTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(AlignmentDirectional alignment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

