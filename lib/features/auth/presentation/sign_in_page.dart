import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(getIt<AuthRepository>()),
      child: const SignInForm(),
    );
  }
}
