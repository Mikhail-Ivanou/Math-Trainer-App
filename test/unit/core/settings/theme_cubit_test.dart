import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  blocTest<ThemeCubit, ThemeState>(
    'starts on the system theme',
    build: () => ThemeCubit(preferences),
    verify: (cubit) => expect(cubit.state, const ThemeSystem()),
  );

  blocTest<ThemeCubit, ThemeState>(
    'persists light theme and restores it',
    build: () => ThemeCubit(preferences),
    act: (cubit) => cubit.setTheme(const ThemeLight()),
    expect: () => const [ThemeLight()],
    verify: (_) async {
      final restored = ThemeCubit(preferences);
      expect(restored.state, const ThemeLight());
      await restored.close();
    },
  );

  blocTest<ThemeCubit, ThemeState>(
    'returns to the system theme',
    build: () => ThemeCubit(preferences),
    act: (cubit) async {
      await cubit.setTheme(const ThemeDark());
      await cubit.setTheme(const ThemeSystem());
    },
    expect: () => const [ThemeDark(), ThemeSystem()],
    verify: (_) async {
      final restored = ThemeCubit(preferences);
      expect(restored.state, const ThemeSystem());
      await restored.close();
    },
  );
}
