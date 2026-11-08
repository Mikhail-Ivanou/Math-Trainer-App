import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/catalog/data/matching/topic_matcher_impl.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/matching.dart';

void main() {
  final fractions = _rule(id: 'fractions', title: 'Adding fractions');
  final area = _rule(id: 'area', title: 'Rectangle area');

  test('local search keeps rules whose title contains a word stem', () {
    final found = filterCatalog('adding fractions please', [fractions, area]);

    expect(found, [fractions]);
  });

  test('the model reply keeps known ids and drops invented ones', () {
    final matches = parseTopicMatches(
      'Sure. {"matches": ['
      '{"id": "fractions", "why": " matches the request "},'
      '{"id": "invented", "why": "no"},'
      '{"id": "fractions", "why": "again"}'
      ']}',
      [fractions, area],
    );

    expect(matches.map((match) => match.rule.id), ['fractions']);
    expect(matches.single.why, 'matches the request');
  });
}

CatalogRule _rule({required String id, required String title}) {
  return CatalogRule(
    id: id,
    title: title,
    bookId: 'book-1',
    bookTitle: 'Algebra',
    subject: 'math',
    chapterTitle: 'Numbers',
    sectionId: 'section-1',
    sectionNumber: 9,
    sectionTitle: 'Natural numbers',
  );
}
