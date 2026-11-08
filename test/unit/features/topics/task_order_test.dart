import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

void main() {
  test('keeps the original order when no task has a date', () {
    final tasks = [_task('a'), _task('b'), _task('c')];

    expect(orderTasksByAddedAt(tasks), tasks);
  });

  test('orders dated tasks from oldest to newest', () {
    final older = _task('old', DateTime.utc(2020));
    final newer = _task('new', DateTime.utc(2024));

    expect(orderTasksByAddedAt([newer, older]).map((task) => task.id), [
      'old',
      'new',
    ]);
  });

  test('leaves a task without a date where it was', () {
    final older = _task('old', DateTime.utc(2020));
    final plain = _task('plain');
    final newer = _task('new', DateTime.utc(2024));

    expect(orderTasksByAddedAt([newer, plain, older]).map((task) => task.id), [
      'old',
      'plain',
      'new',
    ]);
  });
}

Task _task(String id, [DateTime? createdAt]) {
  return Task(
    id: id,
    type: TaskType.expression,
    difficulty: Difficulty.easy,
    question: 'Compute 1 + 1',
    answer: '2',
    createdAt: createdAt,
  );
}
