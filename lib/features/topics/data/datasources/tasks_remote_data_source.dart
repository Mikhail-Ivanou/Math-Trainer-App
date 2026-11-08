import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

abstract interface class TasksRemoteDataSource {
  Stream<List<Task>> watchTasks(String topicId);

  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  });
}
