import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

String topicSubjectLabel(AppLocalizations l10n, String subject) {
  return switch (subject) {
    'math' => l10n.subjectMath,
    _ => subject,
  };
}

String topicListSubtitle(AppLocalizations l10n, Topic topic) {
  final name = topic.subject.isNotEmpty
      ? topicSubjectLabel(l10n, topic.subject)
      : topic.bookTitle;
  if (name.isEmpty) {
    return topic.source;
  }
  return '$name · ${topic.source}';
}
