// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Math Trainer';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInAction => 'Sign in';

  @override
  String get registerAction => 'Create account';

  @override
  String get switchToRegister => 'Need an account? Create one';

  @override
  String get switchToSignIn => 'Already have an account? Sign in';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get missingCredentials => 'Enter your email and password.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get invalidCredentials => 'Email or password is incorrect.';

  @override
  String get emailAlreadyInUse => 'An account with this email already exists.';

  @override
  String get weakPassword => 'Use at least 6 characters.';

  @override
  String get tooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get networkError => 'Check your connection and try again.';

  @override
  String get unexpectedError => 'Something went wrong. Try again.';

  @override
  String get signOut => 'Sign out';

  @override
  String get topicsTab => 'Topics';

  @override
  String get profileTab => 'Profile';

  @override
  String get topicsEmpty => 'No topics yet.';

  @override
  String get accountSection => 'Account';

  @override
  String get settingsSection => 'Settings';

  @override
  String get languageSetting => 'Language';

  @override
  String get themeSetting => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get localeSystem => 'System';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Русский';

  @override
  String get subjectMath => 'Math';

  @override
  String topicGrade(int grade) {
    return 'Grade $grade';
  }

  @override
  String get signedInWithoutEmail => 'Signed in';

  @override
  String solvedProgress(int solved, int total) {
    return 'Solved $solved of $total';
  }

  @override
  String get hideSolved => 'Hide solved';

  @override
  String get showSolved => 'Show solved';

  @override
  String get showAnswer => 'Show answer';

  @override
  String get hideAnswer => 'Hide answer';

  @override
  String get wholeParagraph => 'Whole paragraph';

  @override
  String topicPart(int part) {
    return 'Part $part';
  }

  @override
  String get taskExpression => 'calculate';

  @override
  String get taskEquation => 'equation';

  @override
  String get taskWord => 'problem';

  @override
  String get taskSimplify => 'simplify';

  @override
  String get difficultyEasy => 'easy';

  @override
  String get difficultyMedium => 'medium';

  @override
  String get difficultyHard => 'hard';

  @override
  String get difficultyExpert => 'expert';

  @override
  String get tasksEmpty => 'No problems yet.';

  @override
  String get topicMissing => 'This topic is unavailable.';

  @override
  String get printFailed => 'Couldn\'t create the PDF.';

  @override
  String get showTopic => 'Topic';

  @override
  String get printTasks => 'PDF';
}
