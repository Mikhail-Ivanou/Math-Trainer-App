import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/features/auth/data/firestore/firestore_gateway.dart';

@LazySingleton(as: FirestoreGateway, env: [AppEnv.offline])
class OfflineFirestoreGateway implements FirestoreGateway {
  @override
  bool get isAvailable => false;
}
