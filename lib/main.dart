import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:math_trainer_app/app.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/firebase/firebase_options.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (DefaultFirebaseOptions.isConfigured) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  final environment = DefaultFirebaseOptions.isConfigured
      ? AppEnv.firebase
      : AppEnv.offline;
  await configureDependencies(environment: environment);
  runApp(
    App(
      themeCubit: getIt<ThemeCubit>(),
      localeCubit: getIt<LocaleCubit>(),
      router: getIt<AppRouter>(),
    ),
  );
}
