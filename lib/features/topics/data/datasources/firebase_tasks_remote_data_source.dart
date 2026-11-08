import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/datasources/tasks_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/mappers/generated_task_mapper.dart';
import 'package:math_trainer_app/features/topics/data/mappers/task_mapper.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

@LazySingleton(as: TasksRemoteDataSource)
class FirebaseTasksRemoteDataSource implements TasksRemoteDataSource {
  FirebaseTasksRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Task>> watchTasks(String topicId) {
    return _firestore.collection('topics/$topicId/tasks').snapshots().map((
      snapshot,
    ) {
      return [
        for (final document in snapshot.docs)
          ?TaskMapper.tryFromMap(document.id, document.data()),
      ];
    });
  }

  @override
  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  }) async {
    if (tasks.isEmpty) {
      return;
    }
    final batch = _firestore.batch();
    final collection = _firestore.collection('topics/$topicId/tasks');
    for (final task in tasks) {
      batch.set(
        collection.doc(),
        generatedTaskData(
          task: task,
          userId: userId,
          model: model,
          createdAt: FieldValue.serverTimestamp(),
        ),
      );
    }
    try {
      await batch.commit();
    } catch (error, stackTrace) {
      log(
        'Failed to save generated tasks for topic $topicId\n$error\n$stackTrace',
        name: 'TasksRepository',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        error is Failure ? error : const UnexpectedFailure(),
        stackTrace,
      );
    }
  }
}
