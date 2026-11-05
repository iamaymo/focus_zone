import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Empty state placeholder displayed when no tasks match the current filter or search.
class TaskEmptyView extends StatelessWidget {
  const TaskEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

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
}

