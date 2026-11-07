import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';

typedef TopicGradeGroup = ({int grade, List<Topic> topics});

/// Groups topics by grade after sorting them by paragraph.
List<TopicGradeGroup> groupTopicsByGrade(List<Topic> topics) {
  final sorted = [...topics]..sort(compareTopics);
  final groups = <TopicGradeGroup>[];
  for (final topic in sorted) {
    if (groups.isEmpty || groups.last.grade != topic.grade) {
      groups.add((grade: topic.grade, topics: [topic]));
      continue;
    }
    groups.last.topics.add(topic);
  }
  return [
    for (final group in groups)
      (grade: group.grade, topics: List<Topic>.unmodifiable(group.topics)),
  ];
}
