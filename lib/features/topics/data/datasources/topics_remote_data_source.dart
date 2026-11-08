import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

abstract interface class TopicsRemoteDataSource {
  Stream<List<Topic>> watchTopics();

  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  });
}
