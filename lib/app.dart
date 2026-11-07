import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/locale_state.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

class App extends StatefulWidget {
  const App({
    required this.themeCubit,
    required this.localeCubit,
    required this.authSessionCubit,
    required this.signInCubit,
    required this.router,
    super.key,
  });

  final ThemeCubit themeCubit;
  final LocaleCubit localeCubit;
  final AuthSessionCubit authSessionCubit;
  final SignInCubit signInCubit;
  final AppRouter router;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final RouterConfig<UrlState> _routerConfig = widget.router.config();
  var _navigationReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationReady = true;
      _redirect(widget.authSessionCubit.state);
    });
  }

  void _redirect(AuthSessionState state) {
    if (!_navigationReady) {
      return;
    }
    final router = widget.router;
    switch (state) {
      case AuthSessionUnknown():
        return;
      case AuthSessionSignedOut():
        if (router.current.name == SignInRoute.name) {
          return;
        }
        router.replaceAll([const SignInRoute()]);
      case AuthSessionSignedIn():
        if (router.current.name == PlaceholderRoute.name) {
          return;
        }
        router.replaceAll([const PlaceholderRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.themeCubit),
        BlocProvider.value(value: widget.localeCubit),
        BlocProvider.value(value: widget.authSessionCubit),
        BlocProvider.value(value: widget.signInCubit),
      ],
      child: BlocListener<AuthSessionCubit, AuthSessionState>(
        listener: (_, state) => _redirect(state),
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
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  routerConfig: _routerConfig,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
