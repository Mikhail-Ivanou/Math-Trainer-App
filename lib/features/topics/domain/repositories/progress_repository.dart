abstract interface class ProgressRepository {
  /// Solved task ids for the signed-in user.
  Stream<Set<String>> watchSolvedTaskIds(String userId);

  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  });
}
