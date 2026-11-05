import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';
import '../../../../services/task_service.dart';

/// Header card displaying the current task being worked on, or a general focus banner.
class PomodoroHeaderCard extends StatelessWidget {
  final TaskItem? task;
  final VoidCallback? onTaskStatusChanged;

  const PomodoroHeaderCard({
    super.key,
    required this.task,
    this.onTaskStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    if (task != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.assignment_rounded,
              color: colors.primary,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.workingOn,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task!.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: task!.isCompleted,
              activeColor: colors.primary,
              onChanged: (_) async {
                await TaskService.instance.toggleTaskCompleted(task!);
                onTaskStatusChanged?.call();
              },
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bolt_rounded, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            loc.generalFocus,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

