import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_theme.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/home/presentation/home_page.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'locale_code': 'en'});
    preferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<TopicsRepository>(_FixedTopicsRepository());
    getIt.registerSingleton<HideSolvedRepository>(_HiddenSolvedOff());
  });

  tearDownAll(getIt.reset);

  goldenTest(
    'home topics tab in light and dark themes',
    fileName: 'home_topics_page',
    constraints: const BoxConstraints.tightFor(width: 800, height: 900),
    builder: () => GoldenTestGroup(
      columns: 2,
      columnWidthBuilder: (_) => const FixedColumnWidth(360),
      scenarioConstraints: const BoxConstraints.tightFor(
        width: 360,
        height: 780,
      ),
      children: [
        GoldenTestScenario(
          name: 'light',
          child: _HomeHost(theme: AppTheme.light, preferences: preferences),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: _HomeHost(theme: AppTheme.dark, preferences: preferences),
        ),
      ],
    ),
  );

  goldenTest(
    'home profile tab in light and dark themes',
    fileName: 'home_profile_page',
    constraints: const BoxConstraints.tightFor(width: 800, height: 900),
    builder: () => GoldenTestGroup(
      columns: 2,
      columnWidthBuilder: (_) => const FixedColumnWidth(360),
      scenarioConstraints: const BoxConstraints.tightFor(
        width: 360,
        height: 780,
      ),
      children: [
        GoldenTestScenario(
          name: 'light',
          child: _HomeHost(
            theme: AppTheme.light,
            preferences: preferences,
            initialIndex: 1,
          ),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: _HomeHost(
            theme: AppTheme.dark,
            preferences: preferences,
            initialIndex: 1,
          ),
        ),
      ],
    ),
  );
}

class _HomeHost extends StatelessWidget {
  const _HomeHost({
    required this.theme,
    required this.preferences,
    this.initialIndex = 0,
  });

  final ThemeData theme;
  final SharedPreferences preferences;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthSessionCubit(_SignedInRepository())),
        BlocProvider(create: (_) => ThemeCubit(preferences)),
        BlocProvider(create: (_) => LocaleCubit(preferences)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(initialIndex: initialIndex),
      ),
    );
  }
}

class _SignedInRepository implements AuthRepository {
  @override
  Stream<AuthUser?> watchAuthState() {
    return Stream<AuthUser?>.multi((controller) {
      controller.add(const AuthUser(id: 'user-1', email: 'ada@example.com'));
    });
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}
}

class _HiddenSolvedOff implements HideSolvedRepository {
  @override
  bool get hideSolved => false;

  @override
  Stream<bool> watchHideSolved() => Stream.value(false);

  @override
  Future<void> setHideSolved(bool value) async {}
}

class _FixedTopicsRepository implements TopicsRepository {
  @override
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Topic>> watchTopics() {
    return Stream<List<Topic>>.multi((controller) {
      controller.add(const [
        Topic(
          id: 'rule-1',
          title: 'Fractions',
          rule: 'A fraction names equal parts of a whole. Example: 1/2.',
          grade: 5,
          subject: 'math',
          bookId: 'book-1',
          bookTitle: 'Algebra',
          chapter: 2,
          chapterTitle: 'Numbers',
          sectionId: 'section-4',
          sectionNumber: 4,
          sectionTitle: 'Common fractions',
        ),
      ]);
    });
  }
}
