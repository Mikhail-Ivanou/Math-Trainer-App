import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/repositories/catalog_repository.dart';

@LazySingleton(as: CatalogRepository)
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._dataSource);

  final CatalogRemoteDataSource _dataSource;

  @override
  Future<List<int>> grades() => _guard(_dataSource.grades);

  @override
  Future<List<CatalogRule>> catalog(int grade) {
    return _guard(() => _dataSource.catalog(grade));
  }

  @override
  Future<int?> rememberedGrade(String userId) {
    return _guard(() => _dataSource.rememberedGrade(userId));
  }

  @override
  Future<void> rememberGrade(String userId, int grade) {
    return _guard(() => _dataSource.rememberGrade(userId, grade));
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      log(
        'Catalog request failed\n$error\n$stackTrace',
        name: 'CatalogRepository',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        error is Failure ? error : const UnexpectedFailure(),
        stackTrace,
      );
    }
  }
}
