import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

String taskCaption(AppLocalizations l10n, Task task) {
  return '${_typeLabel(l10n, task.type)} · ${_difficultyLabel(l10n, task.difficulty)}';
}

String _typeLabel(AppLocalizations l10n, TaskType type) {
  return switch (type) {
    TaskType.expression => l10n.taskExpression,
    TaskType.equation => l10n.taskEquation,
    TaskType.word => l10n.taskWord,
    TaskType.simplify => l10n.taskSimplify,
  };
}

String _difficultyLabel(AppLocalizations l10n, Difficulty difficulty) {
  return switch (difficulty) {
    Difficulty.easy => l10n.difficultyEasy,
    Difficulty.medium => l10n.difficultyMedium,
    Difficulty.hard => l10n.difficultyHard,
    Difficulty.expert => l10n.difficultyExpert,
  };
}
