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
    this.createdAt,
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

  /// When the task was added. Missing on tasks stored before this field.
  final DateTime? createdAt;

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
    createdAt,
  ];
}

/// Orders tasks by [Task.createdAt], oldest first.
///
/// A task without a date stays where it is. When no task has a date, the list
/// is returned unchanged.
List<Task> orderTasksByAddedAt(List<Task> tasks) {
  final datedIndexes = <int>[];
  final dated = <Task>[];
  for (var index = 0; index < tasks.length; index++) {
    final task = tasks[index];
    if (task.createdAt != null) {
      datedIndexes.add(index);
      dated.add(task);
    }
  }
  if (dated.isEmpty) {
    return tasks;
  }
  dated.sort((a, b) {
    final aAdded = a.createdAt;
    final bAdded = b.createdAt;
    if (aAdded == null || bAdded == null) {
      return 0;
    }
    return aAdded.compareTo(bAdded);
  });
  final ordered = [...tasks];
  for (var index = 0; index < datedIndexes.length; index++) {
    ordered[datedIndexes[index]] = dated[index];
  }
  return ordered;
}
