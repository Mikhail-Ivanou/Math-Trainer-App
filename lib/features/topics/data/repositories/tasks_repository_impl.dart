import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/reactive/shared_value_stream.dart';
import 'package:math_trainer_app/features/topics/data/datasources/tasks_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';

@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl(this._dataSource);

  final TasksRemoteDataSource _dataSource;
  final _byTopic = <String, SharedValueStream<List<Task>>>{};

  @override
  Stream<List<Task>> watchTasks(String topicId) {
    final cache = _byTopic.putIfAbsent(topicId, SharedValueStream.new);
    return cache.watch(
      () => _dataSource.watchTasks(topicId),
      mapError: _asFailure,
      onRelease: () {
        if (identical(_byTopic[topicId], cache)) {
          _byTopic.remove(topicId);
        }
      },
    );
  }

  @override
  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  }) {
    return _dataSource.addGeneratedTasks(
      topicId: topicId,
      tasks: tasks,
      userId: userId,
      model: model,
    );
  }
}

Object _asFailure(Object error) {
  return error is Failure ? error : const UnexpectedFailure();
}
