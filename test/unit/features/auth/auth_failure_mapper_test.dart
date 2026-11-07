import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/auth_failure_mapper.dart';

void main() {
  test('maps known Firebase auth codes', () {
    expect(mapFirebaseAuthCode('invalid-email'), isA<InvalidEmailFailure>());
    expect(
      mapFirebaseAuthCode('invalid-credential'),
      isA<InvalidCredentialsFailure>(),
    );
    expect(
      mapFirebaseAuthCode('email-already-in-use'),
      isA<EmailAlreadyInUseFailure>(),
    );
    expect(mapFirebaseAuthCode('weak-password'), isA<WeakPasswordFailure>());
    expect(
      mapFirebaseAuthCode('too-many-requests'),
      isA<TooManyRequestsFailure>(),
    );
    expect(
      mapFirebaseAuthCode('network-request-failed'),
      isA<NetworkFailure>(),
    );
    expect(mapFirebaseAuthCode('internal'), isA<UnexpectedFailure>());
  });
}
