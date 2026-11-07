import 'package:flutter/material.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_colors.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppColors get colors {
    return Theme.of(this).extension<AppColors>() ?? AppColors.light;
  }

  AppLocalizations get l10n {
    return AppLocalizations.of(this);
  }
}
