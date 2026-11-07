import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_theme.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/presentation/sign_in_page.dart';
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

void main() {
  goldenTest(
    'sign-in page in light and dark themes',
    fileName: 'sign_in_page',
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
          child: _SignInHost(theme: AppTheme.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: _SignInHost(theme: AppTheme.dark),
        ),
      ],
    ),
  );
}

class _IdleAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> watchAuthState() => const Stream.empty();

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

class _SignInHost extends StatelessWidget {
  const _SignInHost({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(_IdleAuthRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SignInPage(),
      ),
    );
  }
}
