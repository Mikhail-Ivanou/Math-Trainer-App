import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

abstract interface class TasksRepository {
  Stream<List<Task>> watchTasks(String topicId);
}
