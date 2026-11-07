import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource dataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    dataSource = _MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(dataSource);
  });

  test('forwards the signed-in user', () {
    const user = AuthUser(id: 'user-1', email: 'a@b.c');
    when(
      () => dataSource.watchAuthState(),
    ).thenAnswer((_) => Stream.value(user));

    expect(repository.watchAuthState(), emits(user));
  });

  test('maps a raw error to UnexpectedFailure', () {
    when(
      () => dataSource.watchAuthState(),
    ).thenAnswer((_) => Stream.error(Exception('missing firebase')));

    expect(repository.watchAuthState(), emitsError(isA<UnexpectedFailure>()));
  });

  test('maps a sign-in failure thrown by the data source', () {
    when(
      () => dataSource.signInWithEmail(
        email: 'ada@example.com',
        password: 'secret',
      ),
    ).thenThrow(Exception('auth backend'));

    expect(
      repository.signInWithEmail(email: 'ada@example.com', password: 'secret'),
      throwsA(isA<UnexpectedFailure>()),
    );
  });
}
