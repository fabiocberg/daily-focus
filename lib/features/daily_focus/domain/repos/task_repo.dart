import '../entities/task.dart';

abstract class TaskRepo {
  Future<List<Task>> getTasksForDate(DateTime date);
  Future<void> upsertTasks(DateTime date, List<Task> tasks);
}