import 'package:flutter/material.dart';

final class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.danger,
  });

  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color danger;

  static const light = AppColors(
    background: Color(0xFFF4F7F5),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1B2420),
    textSecondary: Color(0xFF5C675F),
    accent: Color(0xFF1F7A4D),
    danger: Color(0xFFB3261E),
  );

  static const dark = AppColors(
    background: Color(0xFF101412),
    surface: Color(0xFF1B2420),
    textPrimary: Color(0xFFF4F7F5),
    textSecondary: Color(0xFFB7C2BA),
    accent: Color(0xFF8FCBAA),
    danger: Color(0xFFFFB4AB),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
    Color? danger,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    Color blend(Color from, Color to) => Color.lerp(from, to, t) ?? from;

    return AppColors(
      background: blend(background, other.background),
      surface: blend(surface, other.surface),
      textPrimary: blend(textPrimary, other.textPrimary),
      textSecondary: blend(textSecondary, other.textSecondary),
      accent: blend(accent, other.accent),
      danger: blend(danger, other.danger),
    );
  }
}
