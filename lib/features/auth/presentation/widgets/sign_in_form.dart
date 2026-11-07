import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/auth/presentation/auth_failure_message.dart';
import 'package:math_trainer_app/features/auth/state/sign_in_cubit.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        final cubit = context.read<SignInCubit>();
        final isRegistering = state.mode == SignInMode.register;
        final failure = state.failure;

        return Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: colors.surface),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isRegistering
                                ? l10n.registerTitle
                                : l10n.signInTitle,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: InputDecoration(
                              labelText: l10n.emailLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            autofillHints: const [AutofillHints.password],
                            decoration: InputDecoration(
                              labelText: l10n.passwordLabel,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          if (failure != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              authFailureMessage(l10n, failure),
                              style: TextStyle(color: colors.danger),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: state.submitting
                                ? null
                                : () => cubit.submit(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                            child: state.submitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isRegistering
                                        ? l10n.registerAction
                                        : l10n.signInAction,
                                  ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: state.submitting
                                ? null
                                : cubit.signInWithGoogle,
                            child: Text(l10n.continueWithGoogle),
                          ),
                          TextButton(
                            onPressed: state.submitting
                                ? null
                                : cubit.toggleMode,
                            child: Text(
                              isRegistering
                                  ? l10n.switchToSignIn
                                  : l10n.switchToRegister,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
