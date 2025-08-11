import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/task.dart';
import '../domain/repos/task_repo.dart';
import '../infrastructure/repos/task_repo_impl.dart';

final todayDateProvider = Provider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final uuid = const Uuid();

final taskRepoProvider = Provider<TaskRepo>((ref) {
  return TaskRepoImpl();
});

final todayTasksProvider =
    StateNotifierProvider<TodayController, AsyncValue<List<Task>>>(
        (ref) => TodayController(ref));

class TodayController extends StateNotifier<AsyncValue<List<Task>>> {
  TodayController(this._ref) : super(const AsyncLoading()) {
    _load();
  }
  final Ref _ref;

  Future<void> _load() async {
    final date = _ref.read(todayDateProvider);
    final repo = _ref.read(taskRepoProvider);
    state = const AsyncLoading();
    try {
      final data = await repo.getTasksForDate(date);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addTask(String title) async {
    final date = _ref.read(todayDateProvider);
    final repo = _ref.read(taskRepoProvider);
    final current = (state.value ?? []);
    if (current.length >= 3) {
      throw StateError('Máximo de 3 tarefas por dia');
    }
    final newTask = Task(id: uuid.v4(), date: date, title: title, done: false);
    final updated = [...current, newTask];
    await repo.upsertTasks(date, updated);
    state = AsyncData(updated);
  }

  Future<void> toggleTask(String id) async {
    final date = _ref.read(todayDateProvider);
    final repo = _ref.read(taskRepoProvider);
    final current = (state.value ?? []);
    final updated = [
      for (final t in current) if (t.id == id) t.toggle() else t
    ];
    await repo.upsertTasks(date, updated);
    state = AsyncData(updated);
  }

  Future<void> resetDay() async {
    final date = _ref.read(todayDateProvider);
    final repo = _ref.read(taskRepoProvider);
    await repo.upsertTasks(date, []);
    state = const AsyncData([]);
  }
}