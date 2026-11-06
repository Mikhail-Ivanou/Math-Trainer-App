import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_theme.dart';
import 'package:math_trainer_app/features/bootstrap/presentation/placeholder_page.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

void main() {
  goldenTest(
    'placeholder page in light and dark themes',
    fileName: 'placeholder_page',
    constraints: const BoxConstraints.tightFor(width: 800, height: 700),
    builder: () => GoldenTestGroup(
      columns: 2,
      columnWidthBuilder: (_) => const FixedColumnWidth(360),
      scenarioConstraints: const BoxConstraints.tightFor(
        width: 360,
        height: 640,
      ),
      children: [
        GoldenTestScenario(
          name: 'light',
          child: _PlaceholderHost(theme: AppTheme.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: _PlaceholderHost(theme: AppTheme.dark),
        ),
      ],
    ),
  );
}

class _PlaceholderHost extends StatelessWidget {
  const _PlaceholderHost({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PlaceholderPage(),
    );
  }
}
