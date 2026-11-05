import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';
import '../../../../services/task_service.dart';
import '../../models/pomodoro_mode.dart';

/// Celebration dialog shown when a Pomodoro focus or break session finishes.
class SessionCompleteDialog extends StatelessWidget {
  final PomodoroMode currentMode;
  final TaskItem? task;
  final VoidCallback onNextSession;
  final VoidCallback? onTaskMarkedDone;

  const SessionCompleteDialog({
    super.key,
    required this.currentMode,
    required this.task,
    required this.onNextSession,
    this.onTaskMarkedDone,
  });

  /// Helper method to display this dialog.
  static Future<void> show(
    BuildContext context, {
    required PomodoroMode currentMode,
    required TaskItem? task,
    required VoidCallback onNextSession,
    VoidCallback? onTaskMarkedDone,
  }) {
    return showDialog(
      context: context,
      builder: (_) => SessionCompleteDialog(
        currentMode: currentMode,
        task: task,
        onNextSession: onNextSession,
        onTaskMarkedDone: onTaskMarkedDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(
            Icons.celebration_rounded,
            color: Colors.amber,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(loc.sessionCompleted)),
        ],
      ),
      content: Text(
        currentMode == PomodoroMode.focus
            ? loc.breakTimeMessage
            : loc.focusTimeMessage,
      ),
      actions: [
        if (task != null && !task!.isCompleted)
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await TaskService.instance.toggleTaskCompleted(task!);
              onTaskMarkedDone?.call();
            },
            child: Text(loc.markTaskAsDone),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onNextSession();
          },
          child: Text(loc.nextSession),
        ),
      ],
    );
  }
}

