import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/topic_similarity.dart';

void main() {
  test('a similar topic is the same grade and the same normalized title', () {
    final existing = Topic(
      id: 'other',
      title: 'Добавление дробей',
      rule: 'A fraction names equal parts.',
      grade: 5,
      subject: 'math',
      bookId: 'book-1',
      bookTitle: 'Algebra',
      chapter: 1,
      chapterTitle: 'Numbers',
      sectionId: 'section-1',
      sectionNumber: 9,
      sectionTitle: 'Natural numbers',
    );
    final rule = CatalogRule(
      id: 'fractions',
      title: 'добавление  дробей',
      bookId: 'book-1',
      bookTitle: 'Algebra',
      subject: 'math',
      chapterTitle: 'Numbers',
      sectionId: 'section-1',
      sectionNumber: 9,
      sectionTitle: 'Natural numbers',
    );

    expect(similarTopic(rule: rule, grade: 5, topics: [existing])?.id, 'other');
    expect(similarTopic(rule: rule, grade: 6, topics: [existing]), isNull);
  });
}
