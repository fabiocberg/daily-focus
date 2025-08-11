import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/task.dart';
import '../domain/repos/task_repo.dart';
import 'today_controller.dart';

final historyProvider = FutureProvider.autoDispose<Map<DateTime, List<Task>>>((ref) async {
  final repo = ref.read(taskRepoProvider);
  final today = ref.read(todayDateProvider);
  final Map<DateTime, List<Task>> result = {};
  for (var i = 1; i <= 7; i++) {
    final d = DateTime(today.year, today.month, today.day).subtract(Duration(days: i));
    final list = await repo.getTasksForDate(d);
    result[d] = list;
  }
  return result;
});