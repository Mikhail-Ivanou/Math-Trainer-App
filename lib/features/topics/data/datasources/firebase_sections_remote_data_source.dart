import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/features/topics/data/datasources/sections_remote_data_source.dart';
import 'package:math_trainer_app/features/topics/data/mappers/section_rule_mapper.dart';

@LazySingleton(as: SectionsRemoteDataSource)
class FirebaseSectionsRemoteDataSource implements SectionsRemoteDataSource {
  FirebaseSectionsRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<String> watchSectionRule(String bookId, String sectionId) {
    return Stream.fromFuture(
      _firestore.doc('books/$bookId/sections/$sectionId').get(),
    ).map((snapshot) => sectionRuleFromMap(snapshot.data()));
  }
}
