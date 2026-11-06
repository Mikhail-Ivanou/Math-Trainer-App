import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({required String environment}) async {
  await getIt.init(environment: environment);
}
