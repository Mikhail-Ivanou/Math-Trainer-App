import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/generation.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';

sealed class TaskGenerationState extends Equatable {
  const TaskGenerationState(this.level);

  final Difficulty level;

  @override
  List<Object?> get props => [level];
}

final class TaskGenerationIdle extends TaskGenerationState {
  const TaskGenerationIdle(super.level);
}

final class TaskGenerationInProgress extends TaskGenerationState {
  const TaskGenerationInProgress(super.level);
}

final class TaskGenerationSuccess extends TaskGenerationState {
  const TaskGenerationSuccess(
    super.level, {
    required this.added,
    required this.rejected,
  });

  final int added;
  final int rejected;

  @override
  List<Object?> get props => [level, added, rejected];
}

final class TaskGenerationFailureState extends TaskGenerationState {
  const TaskGenerationFailureState(super.level, this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [level, failure];
}

class TaskGenerationCubit extends Cubit<TaskGenerationState> {
  TaskGenerationCubit({
    required this.userId,
    required this.generator,
    required this.tasksRepository,
    required this.sectionsRepository,
  }) : super(const TaskGenerationIdle(Difficulty.medium));

  final String userId;
  final TaskGenerator generator;
  final TasksRepository tasksRepository;
  final SectionsRepository sectionsRepository;

  Future<void> generate(Topic topic, Difficulty level) async {
    if (isClosed || state is TaskGenerationInProgress) {
      return;
    }
    _emit(TaskGenerationInProgress(level));
    try {
      final context = await sectionsRepository
          .watchSectionRule(bookId: topic.bookId, sectionId: topic.sectionId)
          .first;
      if (isClosed) {
        return;
      }
      final result = await generator.generate(
        GenerationRequest(
          topicTitle: topic.title,
          rule: topic.rule,
          grade: topic.grade,
          subject: topic.subject,
          level: level,
          context: context,
        ),
      );
      if (isClosed) {
        return;
      }
      if (result.tasks.isEmpty) {
        _emit(
          TaskGenerationFailureState(
            level,
            const GenerationFailure(GenerationProblem.noneValid),
          ),
        );
        return;
      }
      await tasksRepository.addGeneratedTasks(
        topicId: topic.id,
        tasks: result.tasks,
        userId: userId,
        model: result.model,
      );
      _emit(
        TaskGenerationSuccess(
          level,
          added: result.tasks.length,
          rejected: result.rejectedCount,
        ),
      );
    } on Failure catch (failure) {
      _emit(TaskGenerationFailureState(level, failure));
    } catch (_) {
      _emit(TaskGenerationFailureState(level, const UnexpectedFailure()));
    }
  }

  void _emit(TaskGenerationState next) {
    if (isClosed) {
      return;
    }
    emit(next);
  }
}
