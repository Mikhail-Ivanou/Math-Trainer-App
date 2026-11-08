import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/datasources/topics_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/mappers/topic_mapper.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
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

  static const _copiedFields = [
    'bookId',
    'bookTitle',
    'sectionId',
    'grade',
    'subject',
    'chapter',
    'chapterTitle',
    'sectionNumber',
    'sectionTitle',
    'title',
    'rule',
  ];

  @override
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  }) async {
    final topicRef = _firestore.doc('topics/${rule.id}');
    final text = reason.trim();
    try {
      final fields = await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(topicRef);
        final Map<String, dynamic> fields;
        if (existing.exists) {
          fields = existing.data() ?? {};
        } else {
          final ruleSnapshot = await transaction.get(
            _firestore.doc(
              'books/${rule.bookId}/sections/${rule.sectionId}/rules/${rule.id}',
            ),
          );
          final ruleData = ruleSnapshot.data();
          if (ruleData == null) {
            throw StateError('Textbook rule ${rule.id} was not found');
          }
          fields = _copiedRule(ruleData, rule.id);
          transaction.set(topicRef, {
            ...fields,
            'createdBy': userId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        transaction.set(topicRef.collection('requests').doc(userId), {
          'text': text.length <= 500 ? text : text.substring(0, 500),
          'createdAt': FieldValue.serverTimestamp(),
        });
        return fields;
      });
      return TopicMapper.fromMap(rule.id, fields);
    } catch (error, stackTrace) {
      log(
        'Failed to add topic ${rule.id}\n$error\n$stackTrace',
        name: 'TopicsRepository',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        error is Failure ? error : const UnexpectedFailure(),
        stackTrace,
      );
    }
  }

  Map<String, dynamic> _copiedRule(Map<String, dynamic> rule, String ruleId) {
    final fields = <String, dynamic>{};
    for (final key in _copiedFields) {
      final value = rule[key];
      if (value == null) {
        throw StateError('Textbook rule $ruleId is missing $key');
      }
      fields[key] = value;
    }
    return fields;
  }
}
