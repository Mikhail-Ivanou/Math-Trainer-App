import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:math_trainer_app/app.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/firebase/firebase_keys.dart';
import 'package:math_trainer_app/core/firebase/firebase_options.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    await GoogleSignIn.instance.initialize(
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? FirebaseKeys.iosClientId
          : null,
      serverClientId: FirebaseKeys.serverClientId,
    );
  }
  await configureDependencies();
  runApp(
    App(
      themeCubit: getIt<ThemeCubit>(),
      localeCubit: getIt<LocaleCubit>(),
      authSessionCubit: getIt<AuthSessionCubit>(),
      router: getIt<AppRouter>(),
    ),
  );
}
