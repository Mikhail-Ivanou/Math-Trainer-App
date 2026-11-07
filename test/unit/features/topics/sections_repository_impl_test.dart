import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/datasources/sections_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/repositories/sections_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockSectionsRemoteDataSource extends Mock
    implements SectionsRemoteDataSource {}

void main() {
  late SectionsRemoteDataSource dataSource;
  late SectionsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockSectionsRemoteDataSource();
    repository = SectionsRepositoryImpl(dataSource);
  });

  test('replays the section rule without reading twice', () async {
    final controller = StreamController<String>();
    when(
      () => dataSource.watchSectionRule('book-1', 'section-9'),
    ).thenAnswer((_) => controller.stream);

    final first = repository.watchSectionRule(
      bookId: 'book-1',
      sectionId: 'section-9',
    );
    final emitted = expectLater(first, emits('Multiply each term.'));
    controller.add('Multiply each term.');
    await emitted;

    await expectLater(
      repository.watchSectionRule(bookId: 'book-1', sectionId: 'section-9'),
      emits('Multiply each term.'),
    );
    verify(() => dataSource.watchSectionRule('book-1', 'section-9')).called(1);
    await controller.close();
  });

  test('maps a raw error to UnexpectedFailure', () {
    when(
      () => dataSource.watchSectionRule('book-1', 'section-9'),
    ).thenAnswer((_) => Stream.error(Exception('unavailable')));

    expect(
      repository.watchSectionRule(bookId: 'book-1', sectionId: 'section-9'),
      emitsError(isA<UnexpectedFailure>()),
    );
  });
}
