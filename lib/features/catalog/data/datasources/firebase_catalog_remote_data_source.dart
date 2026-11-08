import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:math_trainer_app/features/catalog/data/mappers/catalog_rule_mapper.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';

@LazySingleton(as: CatalogRemoteDataSource)
class FirebaseCatalogRemoteDataSource implements CatalogRemoteDataSource {
  FirebaseCatalogRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<int>> grades() async {
    final snapshot = await _firestore.collection('catalog').get();
    final grades = <int>[];
    for (final document in snapshot.docs) {
      final grade = int.tryParse(document.id.replaceFirst('grade-', ''));
      if (grade != null) {
        grades.add(grade);
      }
    }
    grades.sort();
    return grades;
  }

  @override
  Future<List<CatalogRule>> catalog(int grade) async {
    final snapshot = await _firestore.doc('catalog/grade-$grade').get();
    final rules = snapshot.data()?['rules'];
    if (rules is! List) {
      return const [];
    }
    return [
      for (final rule in rules)
        if (rule is Map)
          ?CatalogRuleMapper.tryFromMap(Map<String, dynamic>.from(rule)),
    ];
  }

  @override
  Future<int?> rememberedGrade(String userId) async {
    if (userId.isEmpty) {
      return null;
    }
    final grade = (await _firestore.doc('users/$userId').get())
        .data()?['grade'];
    return grade is num ? grade.toInt() : null;
  }

  @override
  Future<void> rememberGrade(String userId, int grade) {
    return _firestore.doc('users/$userId').set({
      'grade': grade,
    }, SetOptions(merge: true));
  }
}
