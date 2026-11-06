import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';

sealed class LocaleState extends Equatable {
  const LocaleState();

  Locale? get locale;
}

final class LocaleFollowSystem extends LocaleState {
  const LocaleFollowSystem();

  @override
  Locale? get locale => null;

  @override
  List<Object?> get props => const [];
}

final class LocaleSelected extends LocaleState {
  const LocaleSelected(this.locale);

  @override
  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
