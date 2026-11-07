import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';

@LazySingleton(as: AuthRemoteDataSource, env: [AppEnv.offline])
class OfflineAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Stream<AuthUser?> watchAuthState() => Stream<AuthUser?>.value(null);

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    throw const UnconfiguredFailure();
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) {
    throw const UnconfiguredFailure();
  }

  @override
  Future<void> signInWithGoogle() {
    throw const UnconfiguredFailure();
  }

  @override
  Future<void> signOut() async {}
}
