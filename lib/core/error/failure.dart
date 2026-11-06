import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();
}

final class UnconfiguredFailure extends Failure {
  const UnconfiguredFailure();

  @override
  List<Object?> get props => const [];
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();

  @override
  List<Object?> get props => const [];
}
