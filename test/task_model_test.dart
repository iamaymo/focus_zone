import 'package:flutter_test/flutter_test.dart';
import 'package:focus_zone/core/extensions/task_priority_extension.dart';
import 'package:focus_zone/models/task_item.dart';

void main() {
  group('TaskItem Model Tests', () {
    test('TaskItem serialization and deserialization', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final task = TaskItem(
        id: 'test_1',
        title: 'Complete unit test',
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: now,
      );

      final map = task.toMap();
      expect(map['id'], 'test_1');
      expect(map['title'], 'Complete unit test');
      expect(map['priority'], 'high');
      expect(map['isCompleted'], false);
      expect(map['createdAt'], now.toIso8601String());

      final reconstituted = TaskItem.fromMap(map);
      expect(reconstituted.id, task.id);
      expect(reconstituted.title, task.title);
      expect(reconstituted.priority, task.priority);
      expect(reconstituted.isCompleted, task.isCompleted);
      expect(reconstituted.createdAt, task.createdAt);
    });

    test('TaskItem copyWith creates modified instance', () {
      final task = TaskItem(
        id: '1',
        title: 'Original Title',
        priority: TaskPriority.low,
      );

      final updated = task.copyWith(
        title: 'Updated Title',
        priority: TaskPriority.high,
        isCompleted: true,
      );

      expect(updated.id, '1');
      expect(updated.title, 'Updated Title');
      expect(updated.priority, TaskPriority.high);
      expect(updated.isCompleted, true);
    });

    test('TaskPriorityExtension colors are defined and distinct', () {
      expect(TaskPriority.high.color, isNotNull);
      expect(TaskPriority.medium.color, isNotNull);
      expect(TaskPriority.low.color, isNotNull);
      expect(TaskPriority.high.color != TaskPriority.low.color, isTrue);
    });
  });
}

