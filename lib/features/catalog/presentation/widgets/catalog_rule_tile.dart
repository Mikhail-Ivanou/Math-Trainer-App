import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';

class CatalogRuleTile extends StatelessWidget {
  const CatalogRuleTile({
    required this.rule,
    required this.added,
    required this.similar,
    required this.onTap,
    this.why = '',
    this.showSource = true,
    super.key,
  });

  final CatalogRule rule;
  final bool added;
  final bool similar;
  final String why;
  final bool showSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final subtitle = [
      if (showSource)
        '§ ${rule.sectionNumber}. ${rule.sectionTitle} · ${rule.bookTitle}',
      if (why.isNotEmpty) why,
    ].join('\n');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(rule.title, style: TextStyle(color: colors.textPrimary)),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, style: TextStyle(color: colors.textSecondary)),
      trailing: added
          ? Text(l10n.addTopicAlready, style: TextStyle(color: colors.accent))
          : similar
          ? Text(
              l10n.addTopicSimilarChip,
              style: TextStyle(color: colors.textSecondary),
            )
          : Icon(Icons.add, color: colors.textSecondary),
      onTap: onTap,
    );
  }
}
