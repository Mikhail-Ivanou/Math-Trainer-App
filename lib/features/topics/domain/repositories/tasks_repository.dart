import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

abstract interface class TasksRepository {
  Stream<List<Task>> watchTasks(String topicId);

  /// Writes tasks generated on this phone into the shared topic list.
  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  });
}
