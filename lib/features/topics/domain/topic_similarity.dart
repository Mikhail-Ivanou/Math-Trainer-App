import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

/// An existing topic of the same grade with the same rule name.
Topic? similarTopic({
  required CatalogRule rule,
  required int grade,
  required Iterable<Topic> topics,
}) {
  final title = _normalize(rule.title);
  for (final topic in topics) {
    if (topic.id != rule.id &&
        topic.grade == grade &&
        _normalize(topic.title) == title) {
      return topic;
    }
  }
  return null;
}

String _normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll('ё', 'е')
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim();
}
