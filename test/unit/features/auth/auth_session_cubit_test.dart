import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';

class _StreamAuthRepository implements AuthRepository {
  final _users = StreamController<AuthUser?>.broadcast();

  void add(AuthUser? user) => _users.add(user);

  @override
  Stream<AuthUser?> watchAuthState() => _users.stream;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async => add(null);
}

void main() {
  test('follows the auth stream', () async {
    final repository = _StreamAuthRepository();
    final cubit = AuthSessionCubit(repository);
    addTearDown(cubit.close);
    addTearDown(repository._users.close);

    repository.add(null);
    await expectLater(cubit.stream, emits(const AuthSessionSignedOut()));

    const user = AuthUser(id: 'user-1', email: 'ada@example.com');
    repository.add(user);
    await expectLater(cubit.stream, emits(const AuthSessionSignedIn(user)));
  });
}
