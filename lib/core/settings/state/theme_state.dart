import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  ThemeMode get themeMode;
}

final class ThemeSystem extends ThemeState {
  const ThemeSystem();

  @override
  ThemeMode get themeMode => ThemeMode.system;

  @override
  List<Object?> get props => const [];
}

final class ThemeLight extends ThemeState {
  const ThemeLight();

  @override
  ThemeMode get themeMode => ThemeMode.light;

  @override
  List<Object?> get props => const [];
}

final class ThemeDark extends ThemeState {
  const ThemeDark();

  @override
  ThemeMode get themeMode => ThemeMode.dark;

  @override
  List<Object?> get props => const [];
}
