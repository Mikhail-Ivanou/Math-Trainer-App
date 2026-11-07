import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRemoteDataSource {
  Stream<AuthUser?> watchAuthState();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> registerWithEmail({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signOut();
}
