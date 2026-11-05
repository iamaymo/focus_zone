import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/storage_keys.dart';
import '../models/task_item.dart';

class TaskService extends ChangeNotifier {
  static final TaskService instance = TaskService._internal();
  TaskService._internal();

  static const String boxName = StorageKeys.tasksBox;
  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);

    // Initial demo tasks if empty
    if (_box!.isEmpty) {
      await _insertInitialTasks();
    }
  }

  Future<void> _insertInitialTasks() async {
    final defaultTasks = [
      TaskItem(
        id: '1',
        title: 'جلسة بومودورو أولى للتركيز',
        priority: TaskPriority.high,
        isCompleted: false,
      ),
      TaskItem(
        id: '2',
        title: 'مراجعة قائمة المهام اليومية',
        priority: TaskPriority.medium,
        isCompleted: false,
      ),
      TaskItem(
        id: '3',
        title: 'شرب كوب ماء وأخذ استراحة قصيرة',
        priority: TaskPriority.low,
        isCompleted: true,
      ),
    ];
    for (final task in defaultTasks) {
      await _box!.put(task.id, task.toMap());
    }
  }

  List<TaskItem> getTasks({String filter = 'all'}) {
    if (_box == null) return [];
    final all = <TaskItem>[];
    for (final key in _box!.keys) {
      final data = _box!.get(key);
      if (data is Map) {
        all.add(TaskItem.fromMap(data));
      }
    }

    // Apply priority filter
    List<TaskItem> filtered;
    if (filter == 'all') {
      filtered = all;
    } else {
      filtered = all.where((t) => t.priority.name == filter).toList();
    }

    // Sort: Uncompleted tasks on TOP, Completed tasks moved to the BOTTOM
    filtered.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  Future<void> addTask(TaskItem task) async {
    if (_box == null) return;
    await _box!.put(task.id, task.toMap());
    notifyListeners();
  }

  Future<void> updateTask(TaskItem task) async {
    if (_box == null) return;
    await _box!.put(task.id, task.toMap());
    notifyListeners();
  }

  Future<void> toggleTaskCompleted(TaskItem task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    if (_box == null) return;
    await _box!.delete(id);
    notifyListeners();
  }

  Future<void> deleteAllTasks() async {
    if (_box == null) return;
    await _box!.clear();
    notifyListeners();
  }

  /// Re-add a deleted task (for undo)
  Future<void> restoreTask(TaskItem task) async {
    await addTask(task);
  }
}

