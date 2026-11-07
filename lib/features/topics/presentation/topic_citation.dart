import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/presentation/topic_subject_label.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

String topicCitation(AppLocalizations l10n, Topic topic) {
  final subject = topic.subject.isNotEmpty
      ? topicSubjectLabel(l10n, topic.subject)
      : topic.bookTitle;
  final parts = <String>[
    if (subject.isNotEmpty) subject,
    if (topic.grade > 0) l10n.topicGrade(topic.grade),
    if (topic.chapter > 0) l10n.topicPart(topic.chapter),
  ];
  final head = parts.join('. ');
  if (head.isEmpty) {
    return topic.source;
  }
  return '$head · ${topic.source}';
}
