enum TaskPriority { high, medium, low }

class TaskItem {
  final String id;
  String title;
  TaskPriority priority;
  bool isCompleted;
  DateTime createdAt;

  TaskItem({
    required this.id,
    required this.title,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskItem.fromMap(Map<dynamic, dynamic> map) {
    return TaskItem(
      id: map['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title']?.toString() ?? '',
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      isCompleted: map['isCompleted'] == true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  TaskItem copyWith({
    String? id,
    String? title,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

