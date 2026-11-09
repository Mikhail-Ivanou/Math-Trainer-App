import 'package:flutter/material.dart';
import 'package:math_trainer_app/core/ui_kit/widgets/app_progress_indicator.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.child,
    this.icon,
    this.submitting = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final callback = submitting ? null : onPressed;
    if (submitting || icon == null) {
      return FilledButton(
        onPressed: callback,
        child: submitting ? const AppProgressIndicator() : child,
      );
    }
    return FilledButton.icon(onPressed: callback, icon: icon, label: child);
  }
}
