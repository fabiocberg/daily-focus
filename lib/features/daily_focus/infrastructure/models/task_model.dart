import '../../domain/entities/task.dart';

class TaskModel {
  final String id;
  final DateTime date;
  final String title;
  final bool done;

  const TaskModel({
    required this.id,
    required this.date,
    required this.title,
    required this.done,
  });

  factory TaskModel.fromEntity(Task t) => TaskModel(
        id: t.id,
        date: DateTime(t.date.year, t.date.month, t.date.day),
        title: t.title,
        done: t.done,
      );

  Task toEntity() => Task(id: id, date: date, title: title, done: done);

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'title': title,
        'done': done,
      };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        title: map['title'] as String,
        done: map['done'] as bool,
      );
}