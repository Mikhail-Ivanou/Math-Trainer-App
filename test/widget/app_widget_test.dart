import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/app.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_colors.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart';
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
    final signInCubit = SignInCubit(repository);
    final router = AppRouter();
    addTearDown(themeCubit.close);
    addTearDown(localeCubit.close);
    addTearDown(authSessionCubit.close);
    addTearDown(signInCubit.close);
    addTearDown(repository._users.close);

    await tester.pumpWidget(
      App(
        themeCubit: themeCubit,
        localeCubit: localeCubit,
        authSessionCubit: authSessionCubit,
        signInCubit: signInCubit,
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
    expect(
      Theme.of(signInContext).extension<AppColors>(),
      AppColors.dark,
    );

    await tester.enterText(find.byType(TextField).at(0), 'ada@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Math Trainer'), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });
}
