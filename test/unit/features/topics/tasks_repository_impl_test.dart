import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/datasources/tasks_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/repositories/tasks_repository_impl.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:mocktail/mocktail.dart';

class _MockTasksRemoteDataSource extends Mock
    implements TasksRemoteDataSource {}

void main() {
  late TasksRemoteDataSource dataSource;
  late TasksRepositoryImpl repository;

  setUp(() {
    dataSource = _MockTasksRemoteDataSource();
    repository = TasksRepositoryImpl(dataSource);
  });

  test('replays the latest tasks without listening twice', () async {
    final tasks = [_task('one')];
    final controller = StreamController<List<Task>>();
    when(
      () => dataSource.watchTasks('topic-1'),
    ).thenAnswer((_) => controller.stream);

    final first = repository.watchTasks('topic-1');
    final emitted = expectLater(first, emits(tasks));
    controller.add(tasks);
    await emitted;

    await expectLater(repository.watchTasks('topic-1'), emits(tasks));
    verify(() => dataSource.watchTasks('topic-1')).called(1);
    await controller.close();
  });

  test('maps a raw error to UnexpectedFailure', () {
    when(
      () => dataSource.watchTasks('topic-1'),
    ).thenAnswer((_) => Stream.error(Exception('unavailable')));

    expect(
      repository.watchTasks('topic-1'),
      emitsError(isA<UnexpectedFailure>()),
    );
  });
}

Task _task(String id) {
  return Task(
    id: id,
    type: TaskType.expression,
    difficulty: Difficulty.easy,
    question: id,
    answer: '1',
  );
}
