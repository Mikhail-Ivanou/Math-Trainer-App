/// The solved task id stored in a progress document.
///
/// Rules keep `taskId` in the document body. Older documents used the
/// document id itself.
String? solvedTaskId(String documentId, Map<String, dynamic> data) {
  if (data['solved'] != true) {
    return null;
  }
  final taskId = data['taskId'];
  if (taskId is String && taskId.isNotEmpty) {
    return taskId;
  }
  if (documentId.isEmpty) {
    return null;
  }
  return documentId;
}
