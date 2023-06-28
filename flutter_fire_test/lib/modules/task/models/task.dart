import 'dart:convert';

class Task {
  final String id;
  final String task;
  Task({
    required this.id,
    required this.task,
  });

  Task copyWith({
    String? id,
    String? task,
  }) {
    return Task(
      id: id ?? this.id,
      task: task ?? this.task,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      task: map['task'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Task(id: $id, task: $task)';

  @override
  bool operator ==(covariant Task other) {
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
