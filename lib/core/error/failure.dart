import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();

  @override
  List<Object?> get props => const [];
}

final class MissingCredentialsFailure extends Failure {
  const MissingCredentialsFailure();

  @override
  List<Object?> get props => const [];
}

final class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure();

  @override
  List<Object?> get props => const [];
}

final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();

  @override
  List<Object?> get props => const [];
}

final class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure();

  @override
  List<Object?> get props => const [];
}

final class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure();

  @override
  List<Object?> get props => const [];
}

final class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure();

  @override
  List<Object?> get props => const [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  List<Object?> get props => const [];
}

enum GenerationProblem { unavailable, rejected, quota, empty, noneValid }

final class GenerationFailure extends Failure {
  const GenerationFailure(this.problem);

  final GenerationProblem problem;

  @override
  List<Object?> get props => [problem];
}
