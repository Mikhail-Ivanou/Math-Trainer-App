import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';

@LazySingleton(as: AuthRemoteDataSource, env: [AppEnv.offline])
class OfflineAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Stream<AuthUser?> watchAuthState() => Stream<AuthUser?>.value(null);
}
