import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/features/topics/data/datasources/progress_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/mappers/progress_mapper.dart';

@LazySingleton(as: ProgressRemoteDataSource)
class FirebaseProgressRemoteDataSource implements ProgressRemoteDataSource {
  FirebaseProgressRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  /// `users/{userId}/progress/{taskId}`.
  ///
  /// Rules accept only `topicId`, `taskId`, `solved`, and `updatedAt`,
  /// and `updatedAt` must be the server time.
  @override
  Stream<Set<String>> watchSolvedTaskIds(String userId) {
    return _firestore.collection('users/$userId/progress').snapshots().map((
      snapshot,
    ) {
      return {
        for (final document in snapshot.docs)
          ?solvedTaskId(document.id, document.data()),
      };
    });
  }

  @override
  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  }) {
    return _firestore.collection('users/$userId/progress').doc(taskId).set({
      'topicId': topicId,
      'taskId': taskId,
      'solved': solved,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
