import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';

/// A catalog rule the model thinks matches what the student asked.
final class TopicMatch extends Equatable {
  const TopicMatch({required this.rule, this.why = ''});

  final CatalogRule rule;
  final String why;

  @override
  List<Object?> get props => [rule, why];
}

/// Picks textbook rules for a student's description.
abstract interface class TopicMatcher {
  /// False when the build was compiled without `AIAI_API_KEY`.
  bool get isConfigured;

  Future<List<TopicMatch>> match({
    required String request,
    required List<CatalogRule> catalog,
  });
}

/// A local fallback when no model key is compiled in.
List<CatalogRule> filterCatalog(String query, List<CatalogRule> catalog) {
  final words = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((word) => word.length > 2)
      .toList();
  if (words.isEmpty) {
    return catalog;
  }
  return [
    for (final rule in catalog)
      if (_matches(rule, words)) rule,
  ];
}

bool _matches(CatalogRule rule, List<String> words) {
  final haystack =
      '${rule.title} ${rule.sectionTitle} ${rule.keywords.join(' ')}'
          .toLowerCase();
  return words.any((word) {
    final stem = word.length > 5 ? word.substring(0, word.length - 2) : word;
    return haystack.contains(stem);
  });
}
