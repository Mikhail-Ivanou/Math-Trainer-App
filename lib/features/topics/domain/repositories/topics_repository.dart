import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

abstract interface class TopicsRepository {
  Stream<List<Topic>> watchTopics();
}
