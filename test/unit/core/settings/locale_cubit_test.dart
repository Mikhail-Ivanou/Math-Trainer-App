import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  blocTest<LocaleCubit, LocaleState>(
    'follows the system locale by default',
    build: () => LocaleCubit(preferences),
    verify: (cubit) => expect(cubit.state, const LocaleFollowSystem()),
  );

  blocTest<LocaleCubit, LocaleState>(
    'persists a selected locale and restores it',
    build: () => LocaleCubit(preferences),
    act: (cubit) => cubit.setLocale(const LocaleSelected(Locale('ru'))),
    expect: () => const [LocaleSelected(Locale('ru'))],
    verify: (_) async {
      final restored = LocaleCubit(preferences);
      expect(restored.state, const LocaleSelected(Locale('ru')));
      await restored.close();
    },
  );

  blocTest<LocaleCubit, LocaleState>(
    'clears a selected locale when returning to the system',
    build: () => LocaleCubit(preferences),
    act: (cubit) async {
      await cubit.setLocale(const LocaleSelected(Locale('en')));
      await cubit.setLocale(const LocaleFollowSystem());
    },
    expect: () => const [LocaleSelected(Locale('en')), LocaleFollowSystem()],
    verify: (_) async {
      final restored = LocaleCubit(preferences);
      expect(restored.state, const LocaleFollowSystem());
      await restored.close();
    },
  );
}
