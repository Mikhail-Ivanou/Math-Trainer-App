import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

class App extends StatelessWidget {
  const App({
    required this.themeCubit,
    required this.localeCubit,
    required this.authSessionCubit,
    required this.router,
    super.key,
  });

  final ThemeCubit themeCubit;
  final LocaleCubit localeCubit;
  final AuthSessionCubit authSessionCubit;
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: localeCubit),
        BlocProvider.value(value: authSessionCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appTitle,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: router.config,
              );
            },
          );
        },
      ),
    );
  }
}
