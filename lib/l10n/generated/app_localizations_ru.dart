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
  String get topicsEmpty =>
      'Тем пока нет. Нажмите «Добавить тему» и напишите, что даётся трудно.';

  @override
  String get addTopic => 'Добавить тему';

  @override
  String get addTopicTitle => 'Новая тема';

  @override
  String get addTopicGrade => 'Класс';

  @override
  String get addTopicPrompt => 'Что даётся трудно?';

  @override
  String get addTopicHint => 'например: не понимаю, как складывать дроби';

  @override
  String get addTopicFound => 'Нашлось в учебниках:';

  @override
  String addTopicNone(int grade) {
    return 'В учебниках $grade класса такой темы не нашлось. Попробуйте сформулировать иначе или выберите из списка ниже.';
  }

  @override
  String get addTopicBrowse => 'Или выберите правило из учебника';

  @override
  String get addTopicAlready => 'уже в списке';

  @override
  String get addTopicSimilarChip => 'похожая есть';

  @override
  String get addTopicSimilarTitle => 'Похожая тема уже есть';

  @override
  String addTopicSimilarBody(
    String title,
    String source,
    int section,
    String sectionTitle,
  ) {
    return '«$title» уже добавлена из $source.\nВыбранное правило — из § $section. $sectionTitle. Это может быть то же самое.';
  }

  @override
  String get addTopicAddThis => 'Добавить эту';

  @override
  String get addTopicOpenExisting => 'Открыть существующую';

  @override
  String get addTopicFailed => 'Не удалось добавить тему.';

  @override
  String get catalogFailed => 'Не удалось загрузить учебники.';

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

  @override
  String solvedProgress(int solved, int total) {
    return 'Решено $solved из $total';
  }

  @override
  String get hideSolved => 'Скрыть решённые';

  @override
  String get showSolved => 'Показать решённые';

  @override
  String get showAnswer => 'Показать ответ';

  @override
  String get hideAnswer => 'Скрыть ответ';

  @override
  String get wholeParagraph => 'Весь параграф';

  @override
  String topicPart(int part) {
    return 'Часть $part';
  }

  @override
  String get taskExpression => 'вычисли';

  @override
  String get taskEquation => 'уравнение';

  @override
  String get taskWord => 'задача';

  @override
  String get taskSimplify => 'упрости';

  @override
  String get difficultyEasy => 'легко';

  @override
  String get difficultyMedium => 'среднее';

  @override
  String get difficultyHard => 'сложно';

  @override
  String get difficultyExpert => 'эксперт';

  @override
  String get tasksEmpty => 'Задач пока нет.';

  @override
  String get topicMissing => 'Тема недоступна.';

  @override
  String get printFailed => 'Не удалось создать PDF.';

  @override
  String get showTopic => 'Тема';

  @override
  String get printTasks => 'PDF';

  @override
  String get generateTasks => 'Новые задания';

  @override
  String get generatingTasks => 'Генерирую…';

  @override
  String get generateLevelTitle => 'Уровень заданий';

  @override
  String get generateAction => 'Составить задания';

  @override
  String get levelMedium => 'Средний';

  @override
  String get levelHard => 'Сложный';

  @override
  String get levelExpert => 'Максимальный';

  @override
  String get levelMediumHint =>
      'Как задания из учебника: правило в 2–3 шага, числа побольше';

  @override
  String get levelHardHint =>
      'В 3–5 шагов, вместе с другими правилами, с подвохом';

  @override
  String get levelExpertHint =>
      'Повышенная трудность, почти олимпиада: нужна догадка';

  @override
  String tasksAdded(int count) {
    return 'Добавлено заданий: $count.';
  }

  @override
  String tasksAddedSkipped(int count, int rejected) {
    return 'Добавлено заданий: $count. Отброшено с ошибками: $rejected.';
  }

  @override
  String get generateNone =>
      'Модель не дала ни одного верного задания, попробуйте ещё раз.';

  @override
  String get generateUnavailable => 'Генерация не настроена.';

  @override
  String get generateRejected => 'Ключ генерации не принят.';

  @override
  String get generateQuota => 'Закончился лимит ключа генерации.';

  @override
  String get generateEmpty => 'Модель вернула пустой ответ.';

  @override
  String get tasksEmptyGenerate =>
      'Заданий пока нет. Нажмите «Новые задания», чтобы составить их по теме.';

  @override
  String get allSolved => 'Все задания решены.';

  @override
  String get allSolvedGenerate =>
      'Все задания решены. Нажмите «Новые задания», чтобы получить ещё.';
}
