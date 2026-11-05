import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/preferences_service.dart';
import '../../../../services/task_service.dart';
import '../widgets/danger_tile.dart';

/// Settings page for clearing tasks and resetting the app to factory defaults.
class DataManagementPage extends StatelessWidget {
  const DataManagementPage({super.key});

  Future<void> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) async {
    final loc = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.dataManagement,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Delete all tasks
            DangerTile(
              icon: Icons.delete_sweep_outlined,
              title: loc.deleteAllTasks,
              onTap: () => _confirmAction(
                context,
                title: loc.deleteAllTasks,
                message: loc.deleteAllTasksConfirm,
                onConfirm: () async {
                  await TaskService.instance.deleteAllTasks();
                },
              ),
            ),
            const SizedBox(height: 14),

            // Reset app (gateway + tasks)
            DangerTile(
              icon: Icons.restore_rounded,
              title: loc.resetApp,
              onTap: () => _confirmAction(
                context,
                title: loc.resetApp,
                message: loc.resetAppConfirm,
                onConfirm: () async {
                  await TaskService.instance.deleteAllTasks();
                  await PreferencesService.resetGateway();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

