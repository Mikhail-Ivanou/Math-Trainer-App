import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/generation.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/state/task_generation_cubit.dart';

void main() {
  test('does not emit after the page is closed', () async {
    final result = Completer<GenerationResult>();
    final tasks = _Tasks();
    final cubit = TaskGenerationCubit(
      userId: 'student-1',
      generator: _Generator(result.future),
      tasksRepository: tasks,
      sectionsRepository: _Sections(),
    );

    final pending = cubit.generate(_topic, Difficulty.hard);
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    result.complete(
      const GenerationResult(tasks: [], rejectedCount: 0, model: 'model'),
    );

    await pending;
    expect(tasks.writes, 0);
  });
}

const _topic = Topic(
  id: 'rule-1',
  title: 'Fractions',
  rule: 'A fraction names equal parts.',
  grade: 5,
  subject: 'math',
  bookId: 'book-1',
  bookTitle: 'Algebra',
  chapter: 1,
  chapterTitle: 'Numbers',
  sectionId: 'section-1',
  sectionNumber: 4,
  sectionTitle: 'Common fractions',
);

class _Generator implements TaskGenerator {
  _Generator(this._result);

  final Future<GenerationResult> _result;

  @override
  bool get isConfigured => true;

  @override
  Future<GenerationResult> generate(GenerationRequest request) => _result;
}

class _Sections implements SectionsRepository {
  @override
  Stream<String> watchSectionRule({
    required String bookId,
    required String sectionId,
  }) {
    return Stream.value('More theory.');
  }
}

class _Tasks implements TasksRepository {
  var writes = 0;

  @override
  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  }) async {
    writes++;
  }

  @override
  Stream<List<Task>> watchTasks(String topicId) => Stream.value(const []);
}
