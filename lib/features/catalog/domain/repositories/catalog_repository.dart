import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';

abstract interface class CatalogRepository {
  /// Grades that have a published catalog.
  Future<List<int>> grades();

  Future<List<CatalogRule>> catalog(int grade);

  /// The grade this student picked last time.
  Future<int?> rememberedGrade(String userId);

  Future<void> rememberGrade(String userId, int grade);
}
