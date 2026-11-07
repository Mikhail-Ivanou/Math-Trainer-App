import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/network/rest_client.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'registers application services without constructing Firebase',
    () async {
      SharedPreferences.setMockInitialValues({});
      await configureDependencies();
      addTearDown(getIt.reset);

      expect(getIt.isRegistered<AuthRepository>(), isTrue);
      expect(getIt.isRegistered<TopicsRepository>(), isTrue);
      expect(getIt.isRegistered<SectionsRepository>(), isTrue);
      expect(getIt.isRegistered<TasksRepository>(), isTrue);
      expect(getIt.isRegistered<ProgressRepository>(), isTrue);
      expect(getIt.isRegistered<HideSolvedRepository>(), isTrue);
      expect(getIt<ThemeCubit>().state, const ThemeSystem());
      expect(getIt<LocaleCubit>().state, const LocaleFollowSystem());
      expect(getIt<RestClient>(), isA<RestClient>());
    },
  );
}
