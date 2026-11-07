abstract interface class ProgressRemoteDataSource {
  Stream<Set<String>> watchSolvedTaskIds(String userId);

  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  });
}
