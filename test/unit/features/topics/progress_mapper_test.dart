import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/data/mappers/progress_mapper.dart';

void main() {
  test('reads a solved task id from the document body', () {
    expect(
      solvedTaskId('progress-1', {'taskId': 'task-2', 'solved': true}),
      'task-2',
    );
  });

  test('falls back to the document id', () {
    expect(solvedTaskId('task-2', {'solved': true}), 'task-2');
  });

  test('skips an unsolved document', () {
    expect(
      solvedTaskId('task-2', {'taskId': 'task-2', 'solved': false}),
      isNull,
    );
  });
}
