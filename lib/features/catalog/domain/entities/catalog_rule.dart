import 'package:equatable/equatable.dart';

/// One textbook rule listed in `catalog/grade-{n}`.
final class CatalogRule extends Equatable {
  const CatalogRule({
    required this.id,
    required this.title,
    required this.bookId,
    required this.bookTitle,
    required this.subject,
    required this.chapterTitle,
    required this.sectionId,
    required this.sectionNumber,
    required this.sectionTitle,
    this.keywords = const [],
  });

  final String id;
  final String title;
  final String bookId;
  final String bookTitle;
  final String subject;
  final String chapterTitle;
  final String sectionId;
  final int sectionNumber;
  final String sectionTitle;
  final List<String> keywords;

  @override
  List<Object?> get props => [
    id,
    title,
    bookId,
    bookTitle,
    subject,
    chapterTitle,
    sectionId,
    sectionNumber,
    sectionTitle,
    keywords,
  ];
}
