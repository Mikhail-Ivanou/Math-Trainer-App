import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/firestore/firestore_gateway.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockFirestoreGateway extends Mock implements FirestoreGateway {}

void main() {
  late AuthRemoteDataSource dataSource;
  late FirestoreGateway firestoreGateway;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = _MockAuthRemoteDataSource();
    firestoreGateway = _MockFirestoreGateway();
    repository = AuthRepositoryImpl(dataSource, firestoreGateway);
  });

  test('forwards the signed-in user', () {
    const user = AuthUser(id: 'user-1', email: 'a@b.c');
    when(
      () => dataSource.watchAuthState(),
    ).thenAnswer((_) => Stream.value(user));
    when(() => firestoreGateway.isAvailable).thenReturn(true);

    expect(repository.watchAuthState(), emits(user));
  });

  test('maps a raw error to UnconfiguredFailure when Firebase is offline', () {
    when(
      () => dataSource.watchAuthState(),
    ).thenAnswer((_) => Stream.error(Exception('missing firebase')));
    when(() => firestoreGateway.isAvailable).thenReturn(false);

    expect(repository.watchAuthState(), emitsError(isA<UnconfiguredFailure>()));
  });

  test('maps a raw error to UnexpectedFailure when Firebase is available', () {
    when(
      () => dataSource.watchAuthState(),
    ).thenAnswer((_) => Stream.error(Exception('auth backend')));
    when(() => firestoreGateway.isAvailable).thenReturn(true);

    expect(repository.watchAuthState(), emitsError(isA<UnexpectedFailure>()));
  });
}
