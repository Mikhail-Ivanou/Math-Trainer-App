import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/datasources/topics_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';

@LazySingleton(as: TopicsRepository)
class TopicsRepositoryImpl implements TopicsRepository {
  TopicsRepositoryImpl(this._dataSource);

  final TopicsRemoteDataSource _dataSource;

  @override
  Stream<List<Topic>> watchTopics() {
    return _dataSource.watchTopics().transform(
      StreamTransformer<List<Topic>, List<Topic>>.fromHandlers(
        handleData: (topics, sink) {
          final sorted = [...topics]..sort(compareTopics);
          sink.add(sorted);
        },
        handleError:
            (Object error, StackTrace stackTrace, EventSink<List<Topic>> sink) {
              sink.addError(
                error is Failure ? error : const UnexpectedFailure(),
                stackTrace,
              );
            },
      ),
    );
  }
}
