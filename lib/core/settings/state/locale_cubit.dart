import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._preferences) : super(_read(_preferences));

  static const _storageKey = 'locale_code';

  final SharedPreferences _preferences;

  static LocaleState _read(SharedPreferences preferences) {
    return switch (preferences.getString(_storageKey)) {
      'en' => const LocaleSelected(Locale('en')),
      'ru' => const LocaleSelected(Locale('ru')),
      _ => const LocaleFollowSystem(),
    };
  }

  Future<void> setLocale(LocaleState state) async {
    emit(state);
    switch (state) {
      case LocaleFollowSystem():
        await _preferences.remove(_storageKey);
      case LocaleSelected(:final locale):
        await _preferences.setString(_storageKey, locale.languageCode);
    }
  }
}
