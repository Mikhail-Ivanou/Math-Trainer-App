import 'package:bloc_test/bloc_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/state/topics_cubit.dart';

void main() {
  final topic = Topic(
    id: 'rule-1',
    title: 'Fractions',
    rule: 'A fraction names equal parts.',
    grade: 5,
    subject: 'math',
    bookId: 'book-1',
    bookTitle: 'Algebra',
    chapter: 2,
    chapterTitle: 'Numbers',
    sectionId: 'section-4',
    sectionNumber: 4,
    sectionTitle: 'Common fractions',
  );

  blocTest<TopicsCubit, TopicsState>(
    'emits the topic list',
    build: () => TopicsCubit(_TopicsRepository(Stream.value([topic]))),
    wait: Duration.zero,
    expect: () => [
      TopicsReady([topic]),
    ],
  );

  blocTest<TopicsCubit, TopicsState>(
    'emits a failure when the stream errors',
    build: () =>
        TopicsCubit(_TopicsRepository(Stream.error(const UnexpectedFailure()))),
    wait: Duration.zero,
    expect: () => [const TopicsFailure(UnexpectedFailure())],
  );
}

class _TopicsRepository implements TopicsRepository {
  _TopicsRepository(this._topics);

  final Stream<List<Topic>> _topics;

  @override
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Topic>> watchTopics() => _topics;
}
