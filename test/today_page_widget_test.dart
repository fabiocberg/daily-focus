import 'package:daily_focus/features/daily_focus/application/today_controller.dart';
import 'package:daily_focus/features/daily_focus/domain/entities/task.dart';
import 'package:daily_focus/features/daily_focus/domain/repos/task_repo.dart';
import 'package:daily_focus/features/daily_focus/presentation/pages/today_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TaskRepo {
  List<Task> tasks = [];
  @override
  Future<List<Task>> getTasksForDate(DateTime date) async => tasks;
  @override
  Future<void> upsertTasks(DateTime date, List<Task> tasks) async { this.tasks = tasks; }
}

void main() {
  testWidgets('TodayPage shows empty state and add button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [taskRepoProvider.overrideWithValue(_FakeRepo())],
        child: const MaterialApp(
          home: TodayPage(),
        ),
      ),
    );

    // Aguarda o carregamento assíncrono do controller
    await tester.pumpAndSettle();

    expect(find.textContaining('Defina até 3 prioridades'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}