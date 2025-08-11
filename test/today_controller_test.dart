import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_focus/features/daily_focus/application/today_controller.dart';
import 'package:daily_focus/features/daily_focus/domain/entities/task.dart';
import 'package:daily_focus/features/daily_focus/domain/repos/task_repo.dart';

class _FakeRepo implements TaskRepo {
  final Map<String, List<Task>> store = {};
  String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';
  @override
  Future<List<Task>> getTasksForDate(DateTime date) async => List.of(store[_key(date)] ?? []);
  @override
  Future<void> upsertTasks(DateTime date, List<Task> tasks) async {
    if (tasks.length > 3) throw StateError('Máximo de 3 tarefas por dia');
    store[_key(date)] = List.of(tasks);
  }
}

void main() {
  test('TodayController add/toggle/reset flow', () async {
    final container = ProviderContainer(
      overrides: [
        taskRepoProvider.overrideWithValue(_FakeRepo()),
      ],
    );

    addTearDown(container.dispose);

    final notifier = container.read(todayTasksProvider.notifier);

    await notifier.addTask('T1');
    await notifier.addTask('T2');
    await notifier.addTask('T3');

    // Excede limite
    expect(() => notifier.addTask('T4'), throwsA(isA<StateError>()));

    final data = container.read(todayTasksProvider).value!;
    expect(data.length, 3);

    await notifier.toggleTask(data.first.id);
    final afterToggle = container.read(todayTasksProvider).value!;
    expect(afterToggle.first.done, true);

    await notifier.resetDay();
    final afterReset = container.read(todayTasksProvider).value!;
    expect(afterReset, isEmpty);
  });
}