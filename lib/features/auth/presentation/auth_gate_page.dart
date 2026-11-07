import 'package:math_trainer_app/core/dependencies.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
