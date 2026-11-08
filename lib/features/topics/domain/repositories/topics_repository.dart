import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

abstract interface class TopicsRepository {
  Stream<List<Topic>> watchTopics();

  /// Copies a textbook rule into the shared topic list and records why.
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  });
}
