import 'package:math_trainer_app/core/error/failure.dart';

Failure mapFirebaseAuthCode(String code) {
  return switch (code) {
    'invalid-email' => const InvalidEmailFailure(),
    'user-disabled' ||
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' => const InvalidCredentialsFailure(),
    'email-already-in-use' => const EmailAlreadyInUseFailure(),
    'weak-password' => const WeakPasswordFailure(),
    'too-many-requests' => const TooManyRequestsFailure(),
    'network-request-failed' => const NetworkFailure(),
    _ => const UnexpectedFailure(),
  };
}
