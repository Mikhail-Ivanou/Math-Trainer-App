import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/auth/presentation/auth_gate_page.dart';
import 'package:math_trainer_app/features/auth/presentation/sign_in_page.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/home/presentation/home_page.dart';

abstract final class AppRoutes {
  static const auth = '/';
  static const signIn = '/sign-in';
  static const home = '/home';
}

@lazySingleton
class AppRouter {
  AppRouter(this._authSessionCubit) {
    _refresh = _AuthSessionRefresh(_authSessionCubit);
    config = GoRouter(
      initialLocation: AppRoutes.auth,
      refreshListenable: _refresh,
      redirect: _redirect,
      routes: [
        GoRoute(path: AppRoutes.auth, builder: (_, _) => const AuthGatePage()),
        GoRoute(path: AppRoutes.signIn, builder: (_, _) => const SignInPage()),
        GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
      ],
    );
  }

  final AuthSessionCubit _authSessionCubit;
  late final _AuthSessionRefresh _refresh;
  late final GoRouter config;

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    return switch (_authSessionCubit.state) {
      AuthSessionUnknown() =>
        location == AppRoutes.auth ? null : AppRoutes.auth,
      AuthSessionSignedOut() =>
        location == AppRoutes.signIn ? null : AppRoutes.signIn,
      AuthSessionSignedIn() =>
        location == AppRoutes.home ? null : AppRoutes.home,
    };
  }

  void dispose() {
    config.dispose();
    _refresh.dispose();
  }
}

class _AuthSessionRefresh extends ChangeNotifier {
  _AuthSessionRefresh(AuthSessionCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthSessionState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
