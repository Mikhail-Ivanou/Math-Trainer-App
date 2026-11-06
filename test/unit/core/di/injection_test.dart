import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/network/rest_client.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/features/auth/data/firestore/firestore_gateway.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('offline graph resolves without Firebase', () async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies(environment: AppEnv.offline);
    addTearDown(getIt.reset);

    expect(getIt<FirestoreGateway>().isAvailable, isFalse);
    expect(getIt<AuthRepository>().watchAuthState(), emits(isNull));
    expect(getIt<ThemeCubit>().state, const ThemeSystem());
    expect(getIt<LocaleCubit>().state, const LocaleFollowSystem());
    expect(getIt<RestClient>(), isA<RestClient>());
    expect(getIt<AppRouter>(), isA<AppRouter>());
  });
}
