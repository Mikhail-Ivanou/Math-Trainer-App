import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return _build(brightness: Brightness.light, colors: AppColors.light);
  }

  static ThemeData get dark {
    return _build(brightness: Brightness.dark, colors: AppColors.dark);
  }

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors.accent,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: colors.background,
        elevation: 0,
      ),
      useMaterial3: true,
      extensions: [colors],
    );
  }
}
