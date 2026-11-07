import 'package:equatable/equatable.dart';

/// A textbook rule a student works on.
final class Topic extends Equatable {
  const Topic({
    required this.id,
    required this.title,
    required this.rule,
    required this.grade,
    required this.subject,
    required this.bookId,
    required this.bookTitle,
    required this.chapter,
    required this.chapterTitle,
    required this.sectionId,
    required this.sectionNumber,
    required this.sectionTitle,
    this.paragraph = '',
    this.createdAt,
  });

  final String id;

  /// The rule's name and its statement with an example.
  final String title;
  final String rule;
  final int grade;
  final String subject;
  final String bookId;
  final String bookTitle;
  final int chapter;
  final String chapterTitle;

  /// The paragraph the rule comes from.
  final String sectionId;
  final int sectionNumber;
  final String sectionTitle;

  /// The rest of the textbook paragraph, beyond [rule].
  final String paragraph;
  final DateTime? createdAt;

  String get source => '§ $sectionNumber. $sectionTitle';

  @override
  List<Object?> get props => [
    id,
    title,
    rule,
    grade,
    subject,
    bookId,
    bookTitle,
    chapter,
    chapterTitle,
    sectionId,
    sectionNumber,
    sectionTitle,
    paragraph,
    createdAt,
  ];
}

/// Lower grades come first. Inside a grade, paragraphs come in numeric order.
int compareTopics(Topic a, Topic b) {
  final byGrade = a.grade.compareTo(b.grade);
  if (byGrade != 0) {
    return byGrade;
  }
  final bySection = a.sectionNumber.compareTo(b.sectionNumber);
  if (bySection != 0) {
    return bySection;
  }
  return a.title.compareTo(b.title);
}
