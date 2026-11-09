import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/datasources/topics_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/repositories/topics_repository_impl.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:mocktail/mocktail.dart';

class _MockTopicsRemoteDataSource extends Mock
    implements TopicsRemoteDataSource {}

void main() {
  late TopicsRemoteDataSource dataSource;
  late TopicsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockTopicsRemoteDataSource();
    repository = TopicsRepositoryImpl(dataSource);
  });

  test('orders topics by grade and paragraph', () async {
    final laterParagraph = _topic('later', grade: 5, sectionNumber: 9);
    final earlierParagraph = _topic('earlier', grade: 5, sectionNumber: 2);
    final nextGrade = _topic('sixth', grade: 6, sectionNumber: 1);
    final controller = StreamController<List<Topic>>();
    when(() => dataSource.watchTopics()).thenAnswer((_) => controller.stream);
    addTearDown(controller.close);

    final first = repository.watchTopics().listen(null);
    controller.add([laterParagraph, nextGrade, earlierParagraph]);
    await expectLater(
      repository.watchTopics(),
      emits([earlierParagraph, laterParagraph, nextGrade]),
    );
    verify(() => dataSource.watchTopics()).called(1);
    await first.cancel();
  });

  test('maps a raw error to UnexpectedFailure', () {
    when(
      () => dataSource.watchTopics(),
    ).thenAnswer((_) => Stream.error(Exception('unavailable')));

    expect(repository.watchTopics(), emitsError(isA<UnexpectedFailure>()));
  });
}

Topic _topic(String id, {required int grade, required int sectionNumber}) {
  return Topic(
    id: id,
    title: id,
    rule: '',
    grade: grade,
    subject: 'math',
    bookId: '',
    bookTitle: '',
    chapter: 1,
    chapterTitle: '',
    sectionId: '',
    sectionNumber: sectionNumber,
    sectionTitle: 'Section',
  );
}
