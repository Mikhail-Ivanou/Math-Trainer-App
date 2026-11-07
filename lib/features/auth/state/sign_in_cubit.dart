import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';

enum SignInMode { signIn, register }

final class SignInState extends Equatable {
  const SignInState({
    this.mode = SignInMode.signIn,
    this.submitting = false,
    this.failure,
  });

  final SignInMode mode;
  final bool submitting;
  final Failure? failure;

  SignInState copyWith({
    SignInMode? mode,
    bool? submitting,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return SignInState(
      mode: mode ?? this.mode,
      submitting: submitting ?? this.submitting,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [mode, submitting, failure];
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._repository) : super(const SignInState());

  final AuthRepository _repository;

  void toggleMode() {
    emit(
      state.copyWith(
        mode: state.mode == SignInMode.signIn
            ? SignInMode.register
            : SignInMode.signIn,
        clearFailure: true,
      ),
    );
  }

  Future<void> submit({required String email, required String password}) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          submitting: false,
          failure: const MissingCredentialsFailure(),
        ),
      );
      return;
    }

    emit(state.copyWith(submitting: true, clearFailure: true));
    try {
      if (state.mode == SignInMode.signIn) {
        await _repository.signInWithEmail(
          email: trimmedEmail,
          password: password,
        );
      } else {
        await _repository.registerWithEmail(
          email: trimmedEmail,
          password: password,
        );
      }
      emit(state.copyWith(submitting: false, clearFailure: true));
    } on Failure catch (failure) {
      emit(state.copyWith(submitting: false, failure: failure));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(submitting: true, clearFailure: true));
    try {
      await _repository.signInWithGoogle();
      emit(state.copyWith(submitting: false, clearFailure: true));
    } on Failure catch (failure) {
      emit(state.copyWith(submitting: false, failure: failure));
    }
  }
}
