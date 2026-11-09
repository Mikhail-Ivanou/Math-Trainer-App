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

    final first = repository.watchTasks('topic-1').listen(null);
    controller.add(tasks);
    await expectLater(repository.watchTasks('topic-1'), emits(tasks));

    verify(() => dataSource.watchTasks('topic-1')).called(1);
    await first.cancel();
    await controller.close();
  });

  test('closes the topic listener when nobody is watching', () async {
    final controller = StreamController<List<Task>>();
    when(
      () => dataSource.watchTasks('topic-1'),
    ).thenAnswer((_) => controller.stream);

    final subscription = repository.watchTasks('topic-1').listen(null);
    controller.add([_task('one')]);
    await Future<void>.delayed(Duration.zero);
    expect(controller.hasListener, isTrue);

    await subscription.cancel();
    expect(controller.hasListener, isFalse);
    await controller.close();
  });

  test('reads the topic again after the previous listen failed', () async {
    var opens = 0;
    when(() => dataSource.watchTasks('topic-1')).thenAnswer((_) {
      opens++;
      if (opens == 1) {
        return Stream<List<Task>>.error(Exception('unavailable'));
      }
      return Stream.value([_task('one')]);
    });

    final errors = <Object>[];
    final failed = repository
        .watchTasks('topic-1')
        .listen((_) {}, onError: errors.add);
    await Future<void>.delayed(Duration.zero);
    expect(errors, [isA<UnexpectedFailure>()]);

    await expectLater(repository.watchTasks('topic-1'), emits([_task('one')]));
    expect(opens, 2);
    await failed.cancel();
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
