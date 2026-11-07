// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Тренажёр математики';

  @override
  String get signInTitle => 'Вход';

  @override
  String get registerTitle => 'Создать аккаунт';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get signInAction => 'Войти';

  @override
  String get registerAction => 'Создать аккаунт';

  @override
  String get switchToRegister => 'Нет аккаунта? Создать';

  @override
  String get switchToSignIn => 'Уже есть аккаунт? Войти';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get missingCredentials => 'Введите почту и пароль.';

  @override
  String get invalidEmail => 'Введите корректный адрес почты.';

  @override
  String get invalidCredentials => 'Неверная почта или пароль.';

  @override
  String get emailAlreadyInUse => 'Аккаунт с этой почтой уже существует.';

  @override
  String get weakPassword => 'Используйте не меньше 6 символов.';

  @override
  String get tooManyRequests => 'Слишком много попыток. Попробуйте позже.';

  @override
  String get networkError => 'Проверьте соединение и попробуйте снова.';

  @override
  String get unexpectedError => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get signOut => 'Выйти';

  @override
  String get topicsTab => 'Темы';

  @override
  String get profileTab => 'Профиль';

  @override
  String get topicsEmpty => 'Тем пока нет.';

  @override
  String get accountSection => 'Аккаунт';

  @override
  String get settingsSection => 'Настройки';

  @override
  String get languageSetting => 'Язык';

  @override
  String get themeSetting => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get localeSystem => 'Системный';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get subjectMath => 'Математика';

  @override
  String topicGrade(int grade) {
    return '$grade класс';
  }

  @override
  String get signedInWithoutEmail => 'Вы вошли';
}
