import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> watchAuthState();
}
