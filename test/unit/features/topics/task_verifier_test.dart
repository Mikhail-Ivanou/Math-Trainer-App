import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/verification/rational.dart';
import 'package:math_trainer_app/features/topics/domain/verification/task_verifier.dart';

void main() {
  test('parses grouped digits, decimals, and fractions', () {
    expect(Rational.parse('12 450'), Rational.fromInt(12450));
    expect(Rational.parse('2,5'), Rational(BigInt.from(5), BigInt.from(2)));
    expect(Rational.parse('-0.75'), Rational(BigInt.from(-3), BigInt.from(4)));
    expect(Rational.parse('−7/3'), Rational(BigInt.from(-7), BigInt.from(3)));
    expect(Rational.parse('6/8'), Rational(BigInt.from(3), BigInt.from(4)));
  });

  test('accepts an expression whose answer matches', () {
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.expression,
          difficulty: Difficulty.medium,
          question: 'Compute 12 450 + 1',
          answer: '12451',
          expr: '12450+1',
        ),
      ).ok,
      isTrue,
    );
  });

  test('rejects an expression answer that does not match', () {
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.expression,
          difficulty: Difficulty.medium,
          question: 'Compute 2 + 2',
          answer: '5',
          expr: '2+2',
        ),
      ).ok,
      isFalse,
    );
  });

  test('rejects an expression hidden from the question', () {
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.expression,
          difficulty: Difficulty.medium,
          question: 'Compute the sum',
          answer: '4',
          expr: '2+2',
        ),
      ).reason,
      contains('missing numbers'),
    );
  });

  test('checks an equation by substituting the answer', () {
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.equation,
          difficulty: Difficulty.hard,
          question: 'Solve 3x − 4 = 11',
          answer: '5',
          equation: '3x-4=11',
          variable: 'x',
        ),
      ).ok,
      isTrue,
    );
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.equation,
          difficulty: Difficulty.hard,
          question: 'Solve 3x − 4 = 11',
          answer: '4',
          equation: '3x-4=11',
          variable: 'x',
        ),
      ).ok,
      isFalse,
    );
  });

  test('checks a word problem through its solution', () {
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.word,
          difficulty: Difficulty.medium,
          question: 'A bus travels 60 km in 2 hours. What is its speed?',
          answer: '30',
          solutionExpr: '60/2',
          unit: 'km/h',
        ),
      ).ok,
      isTrue,
    );
  });

  test('accepts an equal simplified expression', () {
    expect(
      verifyTask(
        const Task(
          id: '',
          type: TaskType.simplify,
          difficulty: Difficulty.medium,
          question: 'Simplify 2a + 3a − b',
          answer: '5a-b',
          expr: '2a+3a-b',
        ),
      ).ok,
      isTrue,
    );
  });
}
