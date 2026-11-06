import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/app.dart';
import 'package:math_trainer_app/core/router/app_router.dart';
import 'package:math_trainer_app/core/settings/state/locale_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_cubit.dart';
import 'package:math_trainer_app/core/settings/state/theme_state.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows the english title and applies the selected theme', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'locale_code': 'en'});
    final preferences = await SharedPreferences.getInstance();
    final themeCubit = ThemeCubit(preferences);
    final localeCubit = LocaleCubit(preferences);
    final router = AppRouter();
    addTearDown(themeCubit.close);
    addTearDown(localeCubit.close);

    await tester.pumpWidget(
      App(themeCubit: themeCubit, localeCubit: localeCubit, router: router),
    );
    await tester.pumpAndSettle();

    expect(find.text('Math Trainer'), findsOneWidget);

    await themeCubit.setTheme(const ThemeDark());
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, AppColors.dark.background);
  });
}
