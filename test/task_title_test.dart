import 'package:flutter_test/flutter_test.dart';
import 'package:daily_focus/features/daily_focus/domain/value_objects/task_title.dart';

void main() {
  group('TaskTitle', () {
    test('accepts valid title', () {
      final t = TaskTitle.create('Fazer café');
      expect(t.value, 'Fazer café');
    });

    test('rejects empty', () {
      expect(() => TaskTitle.create('   '), throwsArgumentError);
    });

    test('rejects > 40 chars', () {
      final long = 'x' * 41;
      expect(() => TaskTitle.create(long), throwsArgumentError);
    });
  });
}