import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/features/topics/data/datasources/topics_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/mappers/topic_mapper.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

@LazySingleton(as: TopicsRemoteDataSource)
class FirebaseTopicsRemoteDataSource implements TopicsRemoteDataSource {
  FirebaseTopicsRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const collection = 'topics';

  @override
  Stream<List<Topic>> watchTopics() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return [
        for (final document in snapshot.docs)
          TopicMapper.fromMap(document.id, document.data()),
      ];
    });
  }
}
