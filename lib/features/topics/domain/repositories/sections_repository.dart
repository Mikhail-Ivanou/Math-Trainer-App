abstract interface class SectionsRepository {
  /// The textbook paragraph stored at `books/{bookId}/sections/{sectionId}`.
  Stream<String> watchSectionRule({
    required String bookId,
    required String sectionId,
  });
}
