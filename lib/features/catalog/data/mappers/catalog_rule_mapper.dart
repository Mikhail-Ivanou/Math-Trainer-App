import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';

abstract final class CatalogRuleMapper {
  static CatalogRule? tryFromMap(Map<String, dynamic> data) {
    final id = data['id'];
    final bookId = data['bookId'];
    final sectionId = data['sectionId'];
    if (id is! String || bookId is! String || sectionId is! String) {
      return null;
    }
    if (id.isEmpty || bookId.isEmpty || sectionId.isEmpty) {
      return null;
    }
    final keywords = data['keywords'];
    return CatalogRule(
      id: id,
      title: data['title'] as String? ?? '',
      bookId: bookId,
      bookTitle: data['bookTitle'] as String? ?? '',
      subject: data['subject'] as String? ?? 'math',
      chapterTitle: data['chapterTitle'] as String? ?? '',
      sectionId: sectionId,
      sectionNumber: (data['sectionNumber'] as num?)?.toInt() ?? 0,
      sectionTitle: data['sectionTitle'] as String? ?? '',
      keywords: [
        if (keywords is List)
          for (final keyword in keywords) '$keyword',
      ],
    );
  }
}
