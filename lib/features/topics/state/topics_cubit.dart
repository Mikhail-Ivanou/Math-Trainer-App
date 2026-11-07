import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';

sealed class TopicsState extends Equatable {
  const TopicsState();
}

final class TopicsLoading extends TopicsState {
  const TopicsLoading();

  @override
  List<Object?> get props => const [];
}

final class TopicsReady extends TopicsState {
  const TopicsReady(this.topics);

  final List<Topic> topics;

  @override
  List<Object?> get props => [topics];
}

final class TopicsFailure extends TopicsState {
  const TopicsFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class TopicsCubit extends Cubit<TopicsState> {
  TopicsCubit(this._repository) : super(const TopicsLoading()) {
    _subscription = _repository.watchTopics().listen(
      (topics) => emit(TopicsReady(topics)),
      onError: (Object error) {
        emit(
          TopicsFailure(
            error is Failure ? error : const UnexpectedFailure(),
          ),
        );
      },
    );
  }

  final TopicsRepository _repository;
  late final StreamSubscription<List<Topic>> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
