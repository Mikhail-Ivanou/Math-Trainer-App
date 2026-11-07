import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:rxdart/rxdart.dart';

sealed class TopicPracticeState extends Equatable {
  const TopicPracticeState();
}

final class TopicPracticeLoading extends TopicPracticeState {
  const TopicPracticeLoading();

  @override
  List<Object?> get props => const [];
}

final class TopicPracticeReady extends TopicPracticeState {
  const TopicPracticeReady({
    required this.topic,
    required this.tasks,
    required this.solvedIds,
    required this.hideSolved,
  });

  final Topic? topic;
  final List<Task> tasks;
  final Set<String> solvedIds;
  final bool hideSolved;

  int get solvedCount =>
      tasks.where((task) => solvedIds.contains(task.id)).length;

  int get totalCount => tasks.length;

  List<Task> get visibleTasks => [
    for (final task in tasks)
      if (!hideSolved || !solvedIds.contains(task.id)) task,
  ];

  @override
  List<Object?> get props => [topic, tasks, solvedIds, hideSolved];
}

final class TopicPracticeFailure extends TopicPracticeState {
  const TopicPracticeFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class TopicPracticeCubit extends Cubit<TopicPracticeState> {
  TopicPracticeCubit({
    required this.topicId,
    required this.userId,
    required TopicsRepository topicsRepository,
    required TasksRepository tasksRepository,
    required ProgressRepository progressRepository,
    required HideSolvedRepository hideSolvedRepository,
  }) : _progressRepository = progressRepository,
       _hideSolvedRepository = hideSolvedRepository,
       super(const TopicPracticeLoading()) {
    _subscription =
        Rx.combineLatest4(
          topicsRepository.watchTopics(),
          tasksRepository.watchTasks(topicId),
          progressRepository.watchSolvedTaskIds(userId),
          hideSolvedRepository.watchHideSolved(),
          (
            List<Topic> topics,
            List<Task> tasks,
            Set<String> solvedIds,
            bool hideSolved,
          ) {
            return TopicPracticeReady(
              topic: _topicById(topics, topicId),
              tasks: tasks,
              solvedIds: solvedIds,
              hideSolved: hideSolved,
            );
          },
        ).listen(
          emit,
          onError: (Object error) {
            emit(
              TopicPracticeFailure(
                error is Failure ? error : const UnexpectedFailure(),
              ),
            );
          },
        );
  }

  final String topicId;
  final String userId;
  final ProgressRepository _progressRepository;
  final HideSolvedRepository _hideSolvedRepository;
  late final StreamSubscription<TopicPracticeReady> _subscription;

  Future<void> setSolved(String taskId, bool solved) async {
    try {
      await _progressRepository.setSolved(
        userId: userId,
        topicId: topicId,
        taskId: taskId,
        solved: solved,
      );
    } on Failure {
      // The repository puts the previous progress back.
    }
  }

  Future<void> setHideSolved(bool value) {
    return _hideSolvedRepository.setHideSolved(value);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

Topic? _topicById(List<Topic> topics, String topicId) {
  for (final topic in topics) {
    if (topic.id == topicId) {
      return topic;
    }
  }
  return null;
}
