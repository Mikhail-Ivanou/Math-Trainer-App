import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/data/mappers/topic_mapper.dart';

void main() {
  test('maps a firestore document and fills missing fields', () {
    final createdAt = DateTime.utc(2026, 1, 2);

    final topic = TopicMapper.fromMap('rule-1', {
      'title': 'Fractions',
      'rule': 'A fraction names equal parts.',
      'grade': 5,
      'bookId': 'book-1',
      'bookTitle': 'Algebra',
      'chapter': 2,
      'chapterTitle': 'Numbers',
      'sectionId': 'section-4',
      'sectionNumber': 4,
      'sectionTitle': 'Common fractions',
      'createdAt': Timestamp.fromDate(createdAt),
    });

    expect(topic.id, 'rule-1');
    expect(topic.subject, 'math');
    expect(topic.createdAt, createdAt);
    expect(topic.source, '§ 4. Common fractions');
  });
}
