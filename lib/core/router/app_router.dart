import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/auth/presentation/auth_gate_page.dart';
import 'package:math_trainer_app/features/auth/presentation/sign_in_page.dart';
import 'package:math_trainer_app/features/bootstrap/presentation/placeholder_page.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthGateRoute.page, initial: true),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: PlaceholderRoute.page),
  ];
}
