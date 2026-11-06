import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

@RoutePage()
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.surface),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.appTitle,
              style: TextStyle(color: colors.textPrimary, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
