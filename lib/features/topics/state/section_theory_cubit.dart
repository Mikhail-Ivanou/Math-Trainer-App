import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';

sealed class SectionTheoryState extends Equatable {
  const SectionTheoryState();
}

final class SectionTheoryLoading extends SectionTheoryState {
  const SectionTheoryLoading();

  @override
  List<Object?> get props => const [];
}

final class SectionTheoryReady extends SectionTheoryState {
  const SectionTheoryReady(this.rule);

  final String rule;

  @override
  List<Object?> get props => [rule];
}

final class SectionTheoryFailure extends SectionTheoryState {
  const SectionTheoryFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class SectionTheoryCubit extends Cubit<SectionTheoryState> {
  SectionTheoryCubit({
    required SectionsRepository repository,
    required String bookId,
    required String sectionId,
  }) : super(const SectionTheoryLoading()) {
    _subscription = repository
        .watchSectionRule(bookId: bookId, sectionId: sectionId)
        .listen(
          (rule) => emit(SectionTheoryReady(rule)),
          onError: (Object error) {
            emit(
              SectionTheoryFailure(
                error is Failure ? error : const UnexpectedFailure(),
              ),
            );
          },
        );
  }

  late final StreamSubscription<String> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
