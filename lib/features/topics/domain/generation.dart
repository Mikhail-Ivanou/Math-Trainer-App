import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';

/// What the model should write a batch of tasks about.
final class GenerationRequest extends Equatable {
  const GenerationRequest({
    required this.topicTitle,
    required this.rule,
    required this.grade,
    required this.subject,
    required this.level,
    this.context = '',
  });

  final String topicTitle;
  final String rule;
  final int grade;
  final String subject;
  final Difficulty level;

  /// The rest of the paragraph, so the model knows what the student has seen.
  final String context;

  @override
  List<Object?> get props => [topicTitle, rule, grade, subject, level, context];
}

/// Tasks that passed local answer checks.
final class GenerationResult extends Equatable {
  const GenerationResult({
    required this.tasks,
    required this.rejectedCount,
    required this.model,
  });

  final List<Task> tasks;
  final int rejectedCount;
  final String model;

  @override
  List<Object?> get props => [tasks, rejectedCount, model];
}

abstract interface class TaskGenerator {
  /// False when the build was compiled without `AIAI_API_KEY`.
  bool get isConfigured;

  Future<GenerationResult> generate(GenerationRequest request);
}
