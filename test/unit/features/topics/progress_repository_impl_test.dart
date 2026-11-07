import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/data/datasources/progress_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/repositories/progress_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockProgressRemoteDataSource extends Mock
    implements ProgressRemoteDataSource {}

void main() {
  late ProgressRemoteDataSource dataSource;
  late ProgressRepositoryImpl repository;

  setUp(() {
    dataSource = _MockProgressRemoteDataSource();
    repository = ProgressRepositoryImpl(dataSource);
  });

  test('updates the cached solved ids before the write finishes', () async {
    final controller = StreamController<Set<String>>();
    final writeStarted = Completer<void>();
    when(
      () => dataSource.watchSolvedTaskIds('user-1'),
    ).thenAnswer((_) => controller.stream);
    when(
      () => dataSource.setSolved(
        userId: 'user-1',
        topicId: 'topic-1',
        taskId: 'task-2',
        solved: true,
      ),
    ).thenAnswer((_) => writeStarted.future);

    final seen = <Set<String>>[];
    final subscription = repository
        .watchSolvedTaskIds('user-1')
        .listen(seen.add);
    controller.add(<String>{});
    await Future<void>.delayed(Duration.zero);
    expect(seen, [<String>{}]);

    final write = repository.setSolved(
      userId: 'user-1',
      topicId: 'topic-1',
      taskId: 'task-2',
      solved: true,
    );
    await Future<void>.delayed(Duration.zero);
    expect(seen, [
      <String>{},
      <String>{'task-2'},
    ]);

    writeStarted.complete();
    await write;
    await subscription.cancel();
    await controller.close();
  });
}
