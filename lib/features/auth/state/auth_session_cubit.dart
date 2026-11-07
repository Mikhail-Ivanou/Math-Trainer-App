import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';

sealed class AuthSessionState extends Equatable {
  const AuthSessionState();
}

final class AuthSessionUnknown extends AuthSessionState {
  const AuthSessionUnknown();

  @override
  List<Object?> get props => const [];
}

final class AuthSessionSignedOut extends AuthSessionState {
  const AuthSessionSignedOut();

  @override
  List<Object?> get props => const [];
}

final class AuthSessionSignedIn extends AuthSessionState {
  const AuthSessionSignedIn(this.user);

  final AuthUser user;

  @override
  List<Object?> get props => [user];
}

@lazySingleton
class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit(this._repository) : super(const AuthSessionUnknown()) {
    _subscription = _repository.watchAuthState().listen((user) {
      emit(
        user == null ? const AuthSessionSignedOut() : AuthSessionSignedIn(user),
      );
    }, onError: (_) => emit(const AuthSessionSignedOut()));
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthUser?> _subscription;

  Future<void> signOut() => _repository.signOut();

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
