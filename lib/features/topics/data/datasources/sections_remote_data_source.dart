abstract interface class SectionsRemoteDataSource {
  Stream<String> watchSectionRule(String bookId, String sectionId);
}
