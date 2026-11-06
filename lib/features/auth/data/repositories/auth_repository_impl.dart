import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/data/firestore/firestore_gateway.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._firestoreGateway);

  final AuthRemoteDataSource _dataSource;
  final FirestoreGateway _firestoreGateway;

  @override
  Stream<AuthUser?> watchAuthState() {
    return _dataSource.watchAuthState().transform(
      StreamTransformer<AuthUser?, AuthUser?>.fromHandlers(
        handleData: (data, sink) => sink.add(data),
        handleError:
            (Object error, StackTrace stackTrace, EventSink<AuthUser?> sink) {
              if (error is Failure) {
                sink.addError(error, stackTrace);
                return;
              }
              final failure = _firestoreGateway.isAvailable
                  ? const UnexpectedFailure()
                  : const UnconfiguredFailure();
              sink.addError(failure, stackTrace);
            },
      ),
    );
  }
}
