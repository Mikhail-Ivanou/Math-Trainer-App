import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/reactive/shared_value_stream.dart';
import 'package:math_trainer_app/features/topics/data/datasources/sections_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';

@LazySingleton(as: SectionsRepository)
class SectionsRepositoryImpl implements SectionsRepository {
  SectionsRepositoryImpl(this._dataSource);

  final SectionsRemoteDataSource _dataSource;
  final _bySection = <String, SharedValueStream<String>>{};

  @override
  Stream<String> watchSectionRule({
    required String bookId,
    required String sectionId,
  }) {
    if (bookId.isEmpty || sectionId.isEmpty) {
      return Stream.value('');
    }
    final key = '$bookId/$sectionId';
    final cache = _bySection.putIfAbsent(key, SharedValueStream.new);
    return cache.watch(
      () => _dataSource.watchSectionRule(bookId, sectionId),
      mapError: _asFailure,
      onRelease: () {
        if (identical(_bySection[key], cache)) {
          _bySection.remove(key);
        }
      },
    );
  }
}

Object _asFailure(Object error) {
  return error is Failure ? error : const UnexpectedFailure();
}
