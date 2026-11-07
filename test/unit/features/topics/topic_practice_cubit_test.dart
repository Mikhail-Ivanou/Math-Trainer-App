import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/state/topic_practice_cubit.dart';

void main() {
  final topic = Topic(
    id: 'rule-1',
    title: 'Fractions',
    rule: 'A fraction names equal parts.',
    grade: 5,
    subject: 'math',
    bookId: 'book-1',
    bookTitle: 'Algebra',
    chapter: 1,
    chapterTitle: 'Numbers',
    sectionId: 'section-9',
    sectionNumber: 9,
    sectionTitle: 'Natural numbers',
  );
  final solved = Task(
    id: 'solved',
    type: TaskType.expression,
    difficulty: Difficulty.easy,
    question: 'Compute (20 + 3) · 4',
    answer: '92',
  );
  final open = Task(
    id: 'open',
    type: TaskType.word,
    difficulty: Difficulty.medium,
    question: 'How many pencils?',
    answer: '144',
  );

  blocTest<TopicPracticeCubit, TopicPracticeState>(
    'hides solved tasks and keeps the full progress count',
    build: () => TopicPracticeCubit(
      topicId: topic.id,
      userId: 'user-1',
      topicsRepository: _Topics(Stream.value([topic])),
      tasksRepository: _Tasks(Stream.value([solved, open])),
      progressRepository: _Progress(Stream.value({'solved'})),
      hideSolvedRepository: _HideSolved(true),
    ),
    wait: Duration.zero,
    expect: () => [isA<TopicPracticeReady>()],
    verify: (cubit) {
      final state = cubit.state as TopicPracticeReady;
      expect(state.visibleTasks, [open]);
      expect(state.solvedCount, 1);
      expect(state.totalCount, 2);
    },
  );
}

class _Topics implements TopicsRepository {
  _Topics(this._topics);

  final Stream<List<Topic>> _topics;

  @override
  Stream<List<Topic>> watchTopics() => _topics;
}

class _Tasks implements TasksRepository {
  _Tasks(this._tasks);

  final Stream<List<Task>> _tasks;

  @override
  Stream<List<Task>> watchTasks(String topicId) => _tasks;
}

class _Progress implements ProgressRepository {
  _Progress(this._solved);

  final Stream<Set<String>> _solved;

  @override
  Stream<Set<String>> watchSolvedTaskIds(String userId) => _solved;

  @override
  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  }) async {}
}

class _HideSolved implements HideSolvedRepository {
  _HideSolved(this.hideSolved);

  @override
  final bool hideSolved;

  @override
  Stream<bool> watchHideSolved() => Stream.value(hideSolved);

  @override
  Future<void> setHideSolved(bool value) async {}
}
