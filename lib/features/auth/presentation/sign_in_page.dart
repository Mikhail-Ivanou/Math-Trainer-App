import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/auth/presentation/widgets/sign_in_form.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInForm();
  }
}
