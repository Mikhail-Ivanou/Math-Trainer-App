import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/features/topics/data/datasources/tasks_remote_data_source.dart';
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
}
