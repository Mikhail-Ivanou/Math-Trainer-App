import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
  });

  blocTest<SignInCubit, SignInState>(
    'rejects empty credentials without calling the repository',
    build: () => SignInCubit(repository),
    act: (cubit) => cubit.submit(email: '  ', password: ''),
    expect: () => const [SignInState(failure: MissingCredentialsFailure())],
    verify: (_) {
      verifyNever(
        () => repository.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest<SignInCubit, SignInState>(
    'signs in with a trimmed email',
    build: () => SignInCubit(repository),
    setUp: () {
      when(
        () => repository.signInWithEmail(
          email: 'ada@example.com',
          password: 'secret1',
        ),
      ).thenAnswer((_) async {});
    },
    act: (cubit) =>
        cubit.submit(email: ' ada@example.com ', password: 'secret1'),
    expect: () => const [SignInState(submitting: true), SignInState()],
  );

  blocTest<SignInCubit, SignInState>(
    'registers when create-account mode is selected',
    build: () => SignInCubit(repository),
    setUp: () {
      when(
        () => repository.registerWithEmail(
          email: 'ada@example.com',
          password: 'secret1',
        ),
      ).thenAnswer((_) async {});
    },
    act: (cubit) async {
      cubit.toggleMode();
      await cubit.submit(email: 'ada@example.com', password: 'secret1');
    },
    expect: () => const [
      SignInState(mode: SignInMode.register),
      SignInState(mode: SignInMode.register, submitting: true),
      SignInState(mode: SignInMode.register),
    ],
  );

  blocTest<SignInCubit, SignInState>(
    'shows a repository failure',
    build: () => SignInCubit(repository),
    setUp: () {
      when(
        () => repository.signInWithEmail(
          email: 'ada@example.com',
          password: 'secret1',
        ),
      ).thenThrow(const InvalidCredentialsFailure());
    },
    act: (cubit) => cubit.submit(email: 'ada@example.com', password: 'secret1'),
    expect: () => const [
      SignInState(submitting: true),
      SignInState(failure: InvalidCredentialsFailure()),
    ],
  );

  blocTest<SignInCubit, SignInState>(
    'starts Google sign-in',
    build: () => SignInCubit(repository),
    setUp: () {
      when(() => repository.signInWithGoogle()).thenAnswer((_) async {});
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => const [SignInState(submitting: true), SignInState()],
  );
}
