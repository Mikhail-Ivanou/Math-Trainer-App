import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

String authFailureMessage(AppLocalizations l10n, Failure failure) {
  return switch (failure) {
    MissingCredentialsFailure() => l10n.missingCredentials,
    InvalidEmailFailure() => l10n.invalidEmail,
    InvalidCredentialsFailure() => l10n.invalidCredentials,
    EmailAlreadyInUseFailure() => l10n.emailAlreadyInUse,
    WeakPasswordFailure() => l10n.weakPassword,
    TooManyRequestsFailure() => l10n.tooManyRequests,
    NetworkFailure() => l10n.networkError,
    UnexpectedFailure() => l10n.unexpectedError,
    GenerationFailure() => l10n.unexpectedError,
  };
}
