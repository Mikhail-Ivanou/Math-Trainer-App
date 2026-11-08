import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

String generationFailureMessage(AppLocalizations l10n, Failure failure) {
  return switch (failure) {
    GenerationFailure(:final problem) => switch (problem) {
      GenerationProblem.unavailable => l10n.generateUnavailable,
      GenerationProblem.rejected => l10n.generateRejected,
      GenerationProblem.quota => l10n.generateQuota,
      GenerationProblem.empty => l10n.generateEmpty,
      GenerationProblem.noneValid => l10n.generateNone,
    },
    TooManyRequestsFailure() => l10n.tooManyRequests,
    NetworkFailure() => l10n.networkError,
    _ => l10n.unexpectedError,
  };
}
