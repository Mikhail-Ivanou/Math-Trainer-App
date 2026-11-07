import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

abstract final class TopicMapper {
  static Topic fromMap(String id, Map<String, dynamic> data) {
    return Topic(
      id: id,
      title: data['title'] as String? ?? '',
      rule: data['rule'] as String? ?? '',
      grade: (data['grade'] as num?)?.toInt() ?? 0,
      subject: data['subject'] as String? ?? 'math',
      bookId: data['bookId'] as String? ?? '',
      bookTitle: data['bookTitle'] as String? ?? '',
      chapter: (data['chapter'] as num?)?.toInt() ?? 0,
      chapterTitle: data['chapterTitle'] as String? ?? '',
      sectionId: data['sectionId'] as String? ?? '',
      sectionNumber: (data['sectionNumber'] as num?)?.toInt() ?? 0,
      sectionTitle: data['sectionTitle'] as String? ?? '',
      paragraph: data['paragraph'] as String? ?? '',
      createdAt: _createdAt(data['createdAt']),
    );
  }

  static DateTime? _createdAt(Object? value) {
    return switch (value) {
      final Timestamp timestamp => timestamp.toDate().toUtc(),
      final DateTime dateTime => dateTime.toUtc(),
      _ => null,
    };
  }
}
