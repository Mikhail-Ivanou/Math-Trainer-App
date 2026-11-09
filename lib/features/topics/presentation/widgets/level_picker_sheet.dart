import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

class LevelPickerSheet extends StatefulWidget {
  const LevelPickerSheet({required this.initial, super.key});

  final Difficulty initial;

  @override
  State<LevelPickerSheet> createState() => _LevelPickerSheetState();
}

class _LevelPickerSheetState extends State<LevelPickerSheet> {
  late Difficulty _level = widget.initial;

  static const _levels = [
    Difficulty.medium,
    Difficulty.hard,
    Difficulty.expert,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.generateLevelTitle,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            RadioGroup<Difficulty>(
              groupValue: _level,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _level = value);
                }
              },
              child: Column(
                children: [
                  for (final level in _levels)
                    RadioListTile<Difficulty>(
                      contentPadding: EdgeInsets.zero,
                      value: level,
                      title: Text(
                        _title(l10n, level),
                        style: TextStyle(color: colors.textPrimary),
                      ),
                      subtitle: Text(
                        _hint(l10n, level),
                        style: TextStyle(color: colors.textSecondary),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              onPressed: () => Navigator.of(context).pop(_level),
              icon: const Icon(Icons.auto_awesome),
              child: Text(l10n.generateAction),
            ),
          ],
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n, Difficulty level) {
    return switch (level) {
      Difficulty.medium => l10n.levelMedium,
      Difficulty.hard => l10n.levelHard,
      Difficulty.expert => l10n.levelExpert,
      Difficulty.easy => l10n.levelMedium,
    };
  }

  String _hint(AppLocalizations l10n, Difficulty level) {
    return switch (level) {
      Difficulty.medium => l10n.levelMediumHint,
      Difficulty.hard => l10n.levelHardHint,
      Difficulty.expert => l10n.levelExpertHint,
      Difficulty.easy => l10n.levelMediumHint,
    };
  }
}
