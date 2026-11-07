import 'package:math_trainer_app/core/dependencies.dart';

@RoutePage()
class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.background,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
