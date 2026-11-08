import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/app.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_colors.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  final _users = StreamController<AuthUser?>.broadcast();

  void add(AuthUser? user) => _users.add(user);

  @override
  Stream<AuthUser?> watchAuthState() => _users.stream;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    add(AuthUser(id: 'user-1', email: email));
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async => add(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signs in with email and applies the selected theme', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'locale_code': 'en'});
    final preferences = await SharedPreferences.getInstance();
    final repository = _FakeAuthRepository();
    final themeCubit = ThemeCubit(preferences);
    final localeCubit = LocaleCubit(preferences);
    final authSessionCubit = AuthSessionCubit(repository);
    final router = AppRouter(authSessionCubit);
    getIt.registerSingleton<AuthRepository>(repository);
    getIt.registerSingleton<TopicsRepository>(_ReadyTopicsRepository());
    getIt.registerSingleton<HideSolvedRepository>(_HiddenSolvedOff());
    addTearDown(getIt.reset);
    addTearDown(router.dispose);
    addTearDown(themeCubit.close);
    addTearDown(localeCubit.close);
    addTearDown(authSessionCubit.close);
    addTearDown(repository._users.close);

    await tester.pumpWidget(
      App(
        themeCubit: themeCubit,
        localeCubit: localeCubit,
        authSessionCubit: authSessionCubit,
        router: router,
      ),
    );
    repository.add(null);
    await tester.pump();
    await tester.pump();

    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Continue with Google'), findsOneWidget);

    await themeCubit.setTheme(const ThemeDark());
    await tester.pumpAndSettle();

    final signInContext = tester.element(find.text('Continue with Google'));
    expect(Theme.of(signInContext).extension<AppColors>(), AppColors.dark);

    await tester.enterText(find.byType(TextField).at(0), 'ada@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Topics'), findsWidgets);
    expect(find.text('Fractions'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Hide solved'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.text('Continue with Google'), findsOneWidget);
  });
}

class _HiddenSolvedOff implements HideSolvedRepository {
  @override
  bool get hideSolved => false;

  @override
  Stream<bool> watchHideSolved() => Stream.value(false);

  @override
  Future<void> setHideSolved(bool value) async {}
}

class _ReadyTopicsRepository implements TopicsRepository {
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
    return Stream.value(const [
      Topic(
        id: 'rule-1',
        title: 'Fractions',
        rule: 'A fraction names equal parts.',
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
  }
}
