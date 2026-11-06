import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/features/auth/data/firestore/firestore_gateway.dart';

@LazySingleton(as: FirestoreGateway, env: [AppEnv.firebase])
class FirebaseFirestoreGateway implements FirestoreGateway {
  FirebaseFirestoreGateway(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  bool get isAvailable => _firestore.app.options.projectId.isNotEmpty;
}
