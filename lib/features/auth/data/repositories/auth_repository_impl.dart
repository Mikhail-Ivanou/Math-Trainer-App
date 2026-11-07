import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Stream<AuthUser?> watchAuthState() {
    return _dataSource.watchAuthState().transform(
      StreamTransformer<AuthUser?, AuthUser?>.fromHandlers(
        handleData: (data, sink) => sink.add(data),
        handleError:
            (Object error, StackTrace stackTrace, EventSink<AuthUser?> sink) {
              sink.addError(_mapError(error), stackTrace);
            },
      ),
    );
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _dataSource.signInWithEmail(email: email, password: password),
    );
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _dataSource.registerWithEmail(email: email, password: password),
    );
  }

  @override
  Future<void> signInWithGoogle() {
    return _guard(_dataSource.signInWithGoogle);
  }

  @override
  Future<void> signOut() {
    return _guard(_dataSource.signOut);
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      throw _mapError(error);
    }
  }

  Failure _mapError(Object error) {
    if (error is Failure) {
      return error;
    }
    return const UnexpectedFailure();
  }
}
