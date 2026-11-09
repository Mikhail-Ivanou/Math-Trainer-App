import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/reactive/shared_value_stream.dart';
import 'package:math_trainer_app/features/topics/data/datasources/progress_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';

@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._dataSource);

  final ProgressRemoteDataSource _dataSource;
  final _byUser = <String, SharedValueStream<Set<String>>>{};

  @override
  Stream<Set<String>> watchSolvedTaskIds(String userId) {
    if (userId.isEmpty) {
      return Stream.value(const {});
    }
    final cache = _byUser.putIfAbsent(userId, SharedValueStream.new);
    return cache.watch(
      () => _dataSource.watchSolvedTaskIds(userId),
      mapError: _asFailure,
      onRelease: () {
        if (identical(_byUser[userId], cache)) {
          _byUser.remove(userId);
        }
      },
    );
  }

  @override
  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  }) async {
    if (userId.isEmpty) {
      log(
        'Skipped saving progress because the user id is empty',
        name: 'ProgressRepository',
      );
      return;
    }
    final cache = _byUser.putIfAbsent(userId, SharedValueStream.new);
    final previous = cache.valueOrNull;
    if (previous != null) {
      final next = Set<String>.of(previous);
      if (solved) {
        next.add(taskId);
      } else {
        next.remove(taskId);
      }
      cache.add(next);
    }
    try {
      await _dataSource.setSolved(
        userId: userId,
        topicId: topicId,
        taskId: taskId,
        solved: solved,
      );
    } catch (error, stackTrace) {
      log(
        'Failed to save progress for user $userId, topic $topicId, task $taskId\n'
        '$error\n'
        '$stackTrace',
        name: 'ProgressRepository',
        error: error,
        stackTrace: stackTrace,
      );
      if (previous != null) {
        cache.add(previous);
      }
      Error.throwWithStackTrace(
        error is Failure ? error : const UnexpectedFailure(),
        stackTrace,
      );
    }
  }
}

Object _asFailure(Object error) {
  return error is Failure ? error : const UnexpectedFailure();
}
