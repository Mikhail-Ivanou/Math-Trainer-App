import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/reactive/shared_value_stream.dart';
import 'package:math_trainer_app/features/topics/data/datasources/topics_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';

@LazySingleton(as: TopicsRepository)
class TopicsRepositoryImpl implements TopicsRepository {
  TopicsRepositoryImpl(this._dataSource);

  final TopicsRemoteDataSource _dataSource;
  final _topics = SharedValueStream<List<Topic>>();

  @override
  Stream<List<Topic>> watchTopics() {
    return _topics.watch(() {
      return _dataSource.watchTopics().map((topics) {
        final sorted = [...topics]..sort(compareTopics);
        return sorted;
      });
    }, mapError: _asFailure);
  }
}

Object _asFailure(Object error) {
  return error is Failure ? error : const UnexpectedFailure();
}
