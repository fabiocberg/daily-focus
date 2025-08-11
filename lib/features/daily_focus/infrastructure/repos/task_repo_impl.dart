import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/task.dart';
import '../../domain/repos/task_repo.dart';
import '../models/task_model.dart';

class TaskRepoImpl implements TaskRepo {
  static const boxName = 'tasks';

  Future<Box> _box() async => Hive.openBox(boxName);

  @override
  Future<List<Task>> getTasksForDate(DateTime date) async {
    final box = await _box();
    final key = _key(date);
    final list = (box.get(key, defaultValue: <Map<String, dynamic>>[]) as List)
        .cast<Map>()
        .map((m) => TaskModel.fromMap(Map<String, dynamic>.from(m)))
        .map((m) => m.toEntity())
        .toList();
    return list;
  }

  @override
  Future<void> upsertTasks(DateTime date, List<Task> tasks) async {
    if (tasks.length > 3) {
      throw StateError('Máximo de 3 tarefas por dia');
    }
    final box = await _box();
    final key = _key(date);
    final data = tasks.map((e) => TaskModel.fromEntity(e).toMap()).toList();
    await box.put(key, data);
  }

  String _key(DateTime d) => '${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
}