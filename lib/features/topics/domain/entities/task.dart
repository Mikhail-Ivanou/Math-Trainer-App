import 'package:equatable/equatable.dart';

enum TaskType { expression, equation, word, simplify }

enum Difficulty { easy, medium, hard, expert }

/// One exercise a student can solve and check.
final class Task extends Equatable {
  const Task({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.answer,
    this.expr,
    this.equation,
    this.variable,
    this.solutionExpr,
    this.unit,
  });

  final String id;
  final TaskType type;
  final Difficulty difficulty;
  final String question;

  /// A number, or an expression when [type] is [TaskType.simplify].
  final String answer;

  /// Expression to evaluate, or to simplify.
  final String? expr;

  /// Equation such as `x + 309 = 2542`, with [variable].
  final String? equation;
  final String? variable;

  /// Word problem: an expression that gives the answer.
  final String? solutionExpr;
  final String? unit;

  @override
  List<Object?> get props => [
    id,
    type,
    difficulty,
    question,
    answer,
    expr,
    equation,
    variable,
    solutionExpr,
    unit,
  ];
}
