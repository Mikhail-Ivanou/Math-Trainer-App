import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/data/mappers/generated_task_mapper.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

void main() {
  test('writes exactly the fields the Firestore rule accepts', () {
    final data = generatedTaskData(
      task: const Task(
        id: '',
        type: TaskType.word,
        difficulty: Difficulty.medium,
        question: 'How far?',
        answer: '12',
        solutionExpr: '3*4',
        unit: 'km',
        expr: '',
      ),
      userId: 'user-1',
      model: 'model',
      createdAt: 'server-time',
    );

    expect(data.keys, [
      'type',
      'difficulty',
      'question',
      'answer',
      'source',
      'createdBy',
      'createdAt',
      'model',
      'solution_expr',
      'unit',
    ]);
    expect(data['source'], 'app');
    expect(data['createdBy'], 'user-1');
    expect(data['createdAt'], 'server-time');
    expect(data.containsKey('expr'), isFalse);
  });

  test('trims a model name to the rule limit', () {
    final data = generatedTaskData(
      task: const Task(
        id: '',
        type: TaskType.expression,
        difficulty: Difficulty.easy,
        question: 'Compute 1 + 1',
        answer: '2',
      ),
      userId: 'user-1',
      model: 'm' * 120,
      createdAt: 0,
    );

    expect((data['model'] as String).length, 100);
  });
}
