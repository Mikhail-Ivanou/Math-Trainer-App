import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/profile/state/hide_solved_cubit.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HideSolvedCubit(getIt<HideSolvedRepository>()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.profileTab)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: const [
          _AccountSection(),
          SizedBox(height: 24),
          _SettingsSection(),
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(l10n.accountSection),
        const SizedBox(height: 8),
        BlocBuilder<AuthSessionCubit, AuthSessionState>(
          builder: (context, session) {
            final email = switch (session) {
              AuthSessionSignedIn(:final user) => user.email,
              _ => null,
            };
            return _AccountCard(email: email);
          },
        ),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            email ?? l10n.signedInWithoutEmail,
            style: TextStyle(color: colors.textPrimary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.read<AuthSessionCubit>().signOut(),
            child: Text(l10n.signOut, style: TextStyle(color: colors.danger)),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(l10n.settingsSection),
        const SizedBox(height: 8),
        const _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LanguageSetting(),
              SizedBox(height: 20),
              _ThemeSetting(),
              SizedBox(height: 20),
              _HideSolvedSetting(),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageSetting extends StatelessWidget {
  const _LanguageSetting();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.languageSetting, style: TextStyle(color: colors.textPrimary)),
        const SizedBox(height: 12),
        BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return SegmentedButton<LocaleState>(
              expandedInsets: EdgeInsets.zero,
              showSelectedIcon: false,
              selected: {localeState},
              onSelectionChanged: (selection) {
                context.read<LocaleCubit>().setLocale(selection.first);
              },
              segments: [
                ButtonSegment(
                  value: const LocaleFollowSystem(),
                  label: Text(l10n.localeSystem),
                ),
                ButtonSegment(
                  value: const LocaleSelected(Locale('en')),
                  label: Text(l10n.localeEnglish),
                ),
                ButtonSegment(
                  value: const LocaleSelected(Locale('ru')),
                  label: Text(l10n.localeRussian),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ThemeSetting extends StatelessWidget {
  const _ThemeSetting();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.themeSetting, style: TextStyle(color: colors.textPrimary)),
        const SizedBox(height: 12),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return SegmentedButton<ThemeState>(
              expandedInsets: EdgeInsets.zero,
              showSelectedIcon: false,
              selected: {themeState},
              onSelectionChanged: (selection) {
                context.read<ThemeCubit>().setTheme(selection.first);
              },
              segments: [
                ButtonSegment(
                  value: const ThemeSystem(),
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: const ThemeLight(),
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: const ThemeDark(),
                  label: Text(l10n.themeDark),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _HideSolvedSetting extends StatelessWidget {
  const _HideSolvedSetting();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocBuilder<HideSolvedCubit, bool>(
      builder: (context, hideSolved) {
        return Row(
          children: [
            Expanded(
              child: Text(
                l10n.hideSolved,
                style: TextStyle(color: colors.textPrimary),
              ),
            ),
            Switch(
              value: hideSolved,
              onChanged: context.read<HideSolvedCubit>().setHideSolved,
            ),
          ],
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(label, style: TextStyle(color: colors.textSecondary));
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surface),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
