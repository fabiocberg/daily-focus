class Task {
  final String id;
  final DateTime date; // truncado para yyyy-MM-dd
  final String title;
  final bool done;

  const Task({
    required this.id,
    required this.date,
    required this.title,
    required this.done,
  });

  Task toggle() => Task(id: id, date: date, title: title, done: !done);
}