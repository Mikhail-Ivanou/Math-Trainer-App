import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';

abstract interface class CatalogRemoteDataSource {
  Future<List<int>> grades();

  Future<List<CatalogRule>> catalog(int grade);

  Future<int?> rememberedGrade(String userId);

  Future<void> rememberGrade(String userId, int grade);
}
