import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

abstract interface class TasksRemoteDataSource {
  Stream<List<Task>> watchTasks(String topicId);
}
