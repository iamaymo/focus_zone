import 'package:flutter/material.dart';

import '../../../../core/extensions/task_priority_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';
import '../../../../services/task_service.dart';

/// Modal bottom sheet for creating or editing a task.
class TaskEditorSheet extends StatefulWidget {
  final TaskItem? taskToEdit;

  const TaskEditorSheet({super.key, this.taskToEdit});

  /// Helper method to display this sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, {TaskItem? taskToEdit}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditorSheet(taskToEdit: taskToEdit),
    );
  }

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  late final TextEditingController _titleController;
  late TaskPriority _currentPriority;
  late bool _isDone;

  bool get _isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _currentPriority = widget.taskToEdit?.priority ?? TaskPriority.medium;
    _isDone = widget.taskToEdit?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final text = _titleController.text.trim();
    if (text.isEmpty) return;

    if (_isEditing) {
      final updated = widget.taskToEdit!.copyWith(
        title: text,
        priority: _currentPriority,
        isCompleted: _isDone,
      );
      await TaskService.instance.updateTask(updated);
    } else {
      final newTask = TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: text,
        priority: _currentPriority,
        isCompleted: _isDone,
      );
      await TaskService.instance.addTask(newTask);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _handleDelete() async {
    if (!_isEditing) return;
    await TaskService.instance.deleteTask(widget.taskToEdit!.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

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
                  _isEditing ? loc.editTask : loc.addTask,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
                    tooltip: loc.delete,
                    onPressed: _handleDelete,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Task title field
            TextField(
              controller: _titleController,
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
                final isSelected = _currentPriority == priority;
                final pColor = priority.color;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentPriority = priority;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                          priority.label(context),
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
              value: _isDone,
              onChanged: (val) {
                setState(() {
                  _isDone = val ?? false;
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
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: _handleSave,
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
  }
}

