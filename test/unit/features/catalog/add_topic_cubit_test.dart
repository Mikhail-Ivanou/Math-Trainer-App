import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/matching.dart';
import 'package:math_trainer_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:math_trainer_app/features/catalog/state/add_topic_cubit.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';

void main() {
  test(
    'a slow grade response does not replace the grade picked later',
    () async {
      final catalog = _Catalog();
      final cubit = AddTopicCubit(
        userId: 'student-1',
        catalogRepository: catalog,
        topicsRepository: _Topics(),
        matcher: const _Matcher(),
      );
      addTearDown(cubit.close);

      await cubit.load();
      catalog.hold = true;
      final older = cubit.selectGrade(6);
      final newer = cubit.selectGrade(5);
      catalog.finish(6, [_rule('from-6')]);
      await Future<void>.delayed(Duration.zero);

      final waiting = cubit.state;
      expect(waiting, isA<AddTopicReady>());
      expect((waiting as AddTopicReady).grade, 5);
      expect(waiting.catalog, isEmpty);

      catalog.finish(5, [_rule('from-5')]);
      await Future.wait([older, newer]);

      final ready = cubit.state as AddTopicReady;
      expect(ready.grade, 5);
      expect(ready.catalog.single.id, 'from-5');
      expect(ready.loadingCatalog, isFalse);
    },
  );

  test('a failed grade load keeps the form on screen', () async {
    final catalog = _Catalog();
    final cubit = AddTopicCubit(
      userId: 'student-1',
      catalogRepository: catalog,
      topicsRepository: _Topics(),
      matcher: const _Matcher(),
    );
    addTearDown(cubit.close);

    await cubit.load();
    catalog.failGrade = 6;
    await cubit.selectGrade(6);

    final ready = cubit.state;
    expect(ready, isA<AddTopicReady>());
    expect((ready as AddTopicReady).failure, const UnexpectedFailure());
    expect(ready.grade, 6);
    expect(ready.loadingCatalog, isFalse);
  });
}

CatalogRule _rule(String id) {
  return CatalogRule(
    id: id,
    title: id,
    bookId: 'book-1',
    bookTitle: 'Algebra',
    subject: 'math',
    chapterTitle: 'Numbers',
    sectionId: 'section-1',
    sectionNumber: 1,
    sectionTitle: 'Numbers',
  );
}

class _Catalog implements CatalogRepository {
  final _pending = <int, Completer<List<CatalogRule>>>{};
  var hold = false;
  int? failGrade;

  @override
  Future<List<int>> grades() async => const [5, 6];

  @override
  Future<List<CatalogRule>> catalog(int grade) {
    if (grade == failGrade) {
      return Future<List<CatalogRule>>.error(const UnexpectedFailure());
    }
    if (!hold && grade == 5) {
      return Future.value([_rule('grade-5')]);
    }
    return _pending.putIfAbsent(grade, Completer<List<CatalogRule>>.new).future;
  }

  void finish(int grade, List<CatalogRule> rules) {
    _pending[grade]?.complete(rules);
  }

  @override
  Future<int?> rememberedGrade(String userId) async => 5;

  @override
  Future<void> rememberGrade(String userId, int grade) async {}
}

class _Topics implements TopicsRepository {
  @override
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Topic>> watchTopics() => Stream.value(const []);
}

class _Matcher implements TopicMatcher {
  const _Matcher();

  @override
  bool get isConfigured => false;

  @override
  Future<List<TopicMatch>> match({
    required String request,
    required List<CatalogRule> catalog,
  }) {
    throw UnimplementedError();
  }
}
