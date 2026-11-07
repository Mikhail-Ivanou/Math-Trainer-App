import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

abstract interface class TopicsRemoteDataSource {
  Stream<List<Topic>> watchTopics();
}
