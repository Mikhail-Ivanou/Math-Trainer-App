import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Math Trainer'**
  String get appTitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInAction;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerAction;

  /// No description provided for @switchToRegister.
  ///
  /// In en, this message translates to:
  /// **'Need an account? Create one'**
  String get switchToRegister;

  /// No description provided for @switchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get switchToSignIn;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @missingCredentials.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password.'**
  String get missingCredentials;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get weakPassword;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get tooManyRequests;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get networkError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get unexpectedError;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @topicsTab.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topicsTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @topicsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No topics yet.'**
  String get topicsEmpty;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @settingsSection.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSection;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @themeSetting.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSetting;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @localeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get localeSystem;

  /// No description provided for @localeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// No description provided for @localeRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get localeRussian;

  /// No description provided for @subjectMath.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get subjectMath;

  /// No description provided for @topicGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String topicGrade(int grade);

  /// No description provided for @signedInWithoutEmail.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedInWithoutEmail;

  /// No description provided for @solvedProgress.
  ///
  /// In en, this message translates to:
  /// **'Solved {solved} of {total}'**
  String solvedProgress(int solved, int total);

  /// No description provided for @hideSolved.
  ///
  /// In en, this message translates to:
  /// **'Hide solved'**
  String get hideSolved;

  /// No description provided for @showSolved.
  ///
  /// In en, this message translates to:
  /// **'Show solved'**
  String get showSolved;

  /// No description provided for @showAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// No description provided for @hideAnswer.
  ///
  /// In en, this message translates to:
  /// **'Hide answer'**
  String get hideAnswer;

  /// No description provided for @wholeParagraph.
  ///
  /// In en, this message translates to:
  /// **'Whole paragraph'**
  String get wholeParagraph;

  /// No description provided for @topicPart.
  ///
  /// In en, this message translates to:
  /// **'Part {part}'**
  String topicPart(int part);

  /// No description provided for @taskExpression.
  ///
  /// In en, this message translates to:
  /// **'calculate'**
  String get taskExpression;

  /// No description provided for @taskEquation.
  ///
  /// In en, this message translates to:
  /// **'equation'**
  String get taskEquation;

  /// No description provided for @taskWord.
  ///
  /// In en, this message translates to:
  /// **'problem'**
  String get taskWord;

  /// No description provided for @taskSimplify.
  ///
  /// In en, this message translates to:
  /// **'simplify'**
  String get taskSimplify;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'hard'**
  String get difficultyHard;

  /// No description provided for @difficultyExpert.
  ///
  /// In en, this message translates to:
  /// **'expert'**
  String get difficultyExpert;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No problems yet.'**
  String get tasksEmpty;

  /// No description provided for @topicMissing.
  ///
  /// In en, this message translates to:
  /// **'This topic is unavailable.'**
  String get topicMissing;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the PDF.'**
  String get printFailed;

  /// No description provided for @showTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get showTopic;

  /// No description provided for @printTasks.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get printTasks;

  /// No description provided for @generateTasks.
  ///
  /// In en, this message translates to:
  /// **'New problems'**
  String get generateTasks;

  /// No description provided for @generatingTasks.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get generatingTasks;

  /// No description provided for @generateLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Problem level'**
  String get generateLevelTitle;

  /// No description provided for @generateAction.
  ///
  /// In en, this message translates to:
  /// **'Create problems'**
  String get generateAction;

  /// No description provided for @levelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get levelMedium;

  /// No description provided for @levelHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get levelHard;

  /// No description provided for @levelExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get levelExpert;

  /// No description provided for @levelMediumHint.
  ///
  /// In en, this message translates to:
  /// **'Like the textbook: the rule in 2–3 steps, larger numbers'**
  String get levelMediumHint;

  /// No description provided for @levelHardHint.
  ///
  /// In en, this message translates to:
  /// **'3–5 steps, mixed with earlier rules, with a trap'**
  String get levelHardHint;

  /// No description provided for @levelExpertHint.
  ///
  /// In en, this message translates to:
  /// **'A hard problem for this grade: it needs an idea, not a long calculation'**
  String get levelExpertHint;

  /// No description provided for @tasksAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {count} problems.'**
  String tasksAdded(int count);

  /// No description provided for @tasksAddedSkipped.
  ///
  /// In en, this message translates to:
  /// **'Added {count} problems. Rejected {rejected}.'**
  String tasksAddedSkipped(int count, int rejected);

  /// No description provided for @generateNone.
  ///
  /// In en, this message translates to:
  /// **'The model returned no valid problems. Try again.'**
  String get generateNone;

  /// No description provided for @generateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Generation is not configured.'**
  String get generateUnavailable;

  /// No description provided for @generateRejected.
  ///
  /// In en, this message translates to:
  /// **'The generation key was rejected.'**
  String get generateRejected;

  /// No description provided for @generateQuota.
  ///
  /// In en, this message translates to:
  /// **'The generation key has no remaining quota.'**
  String get generateQuota;

  /// No description provided for @generateEmpty.
  ///
  /// In en, this message translates to:
  /// **'The model returned an empty answer.'**
  String get generateEmpty;

  /// No description provided for @tasksEmptyGenerate.
  ///
  /// In en, this message translates to:
  /// **'No problems yet. Tap New problems to write some for this topic.'**
  String get tasksEmptyGenerate;

  /// No description provided for @allSolved.
  ///
  /// In en, this message translates to:
  /// **'Every problem is solved.'**
  String get allSolved;

  /// No description provided for @allSolvedGenerate.
  ///
  /// In en, this message translates to:
  /// **'Every problem is solved. Tap New problems to get more.'**
  String get allSolvedGenerate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
