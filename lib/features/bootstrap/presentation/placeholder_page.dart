import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

@RoutePage()
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);
    final session = context.watch<AuthSessionCubit>().state;
    final email = switch (session) {
      AuthSessionSignedIn(:final user) => user.email,
      _ => null,
    };

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.surface),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.appTitle,
                  style: TextStyle(color: colors.textPrimary, fontSize: 24),
                ),
                if (email != null) ...[
                  const SizedBox(height: 8),
                  Text(email, style: TextStyle(color: colors.textSecondary)),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.read<AuthSessionCubit>().signOut(),
                  child: Text(l10n.signOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
