import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._preferences) : super(_read(_preferences));

  static const _storageKey = 'theme_mode';

  final SharedPreferences _preferences;

  static ThemeState _read(SharedPreferences preferences) {
    return switch (preferences.getString(_storageKey)) {
      'light' => const ThemeLight(),
      'dark' => const ThemeDark(),
      _ => const ThemeSystem(),
    };
  }

  Future<void> setTheme(ThemeState state) async {
    emit(state);
    final value = switch (state) {
      ThemeSystem() => 'system',
      ThemeLight() => 'light',
      ThemeDark() => 'dark',
    };
    await _preferences.setString(_storageKey, value);
  }
}
