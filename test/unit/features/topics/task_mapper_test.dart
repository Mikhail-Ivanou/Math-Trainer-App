import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/data/mappers/task_mapper.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

void main() {
  test('maps a task document', () {
    final task = TaskMapper.fromMap('task-1', {
      'type': 'equation',
      'difficulty': 'medium',
      'question': 'Solve x + 1 = 2',
      'answer': '1',
      'equation': 'x + 1 = 2',
      'variable': 'x',
      'unit': 'cm',
    });

    expect(
      task,
      const Task(
        id: 'task-1',
        type: TaskType.equation,
        difficulty: Difficulty.medium,
        question: 'Solve x + 1 = 2',
        answer: '1',
        equation: 'x + 1 = 2',
        variable: 'x',
        unit: 'cm',
      ),
    );
  });

  test('reads the date the task was added', () {
    final added = DateTime.utc(2026, 3, 4);

    final task = TaskMapper.fromMap('task-1', {
      'type': 'expression',
      'difficulty': 'easy',
      'question': 'Compute 1 + 1',
      'answer': '2',
      'createdAt': Timestamp.fromDate(added),
    });

    expect(task.createdAt, added);
  });

  test('skips a task without a question', () {
    expect(
      TaskMapper.tryFromMap('task-1', {
        'type': 'expression',
        'difficulty': 'easy',
        'answer': '1',
      }),
      isNull,
    );
  });
}
