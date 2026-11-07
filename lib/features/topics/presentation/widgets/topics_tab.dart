import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/domain/topic_groups.dart';
import 'package:math_trainer_app/features/topics/presentation/topic_subject_label.dart';
import 'package:math_trainer_app/features/topics/state/topics_cubit.dart';

class TopicsTab extends StatelessWidget {
  const TopicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopicsCubit(getIt<TopicsRepository>()),
      child: const _TopicsView(),
    );
  }
}

class _TopicsView extends StatelessWidget {
  const _TopicsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: Text(l10n.topicsTab),
      ),
      body: BlocBuilder<TopicsCubit, TopicsState>(
        builder: (context, state) => _TopicsBody(state: state),
      ),
    );
  }
}

class _TopicsBody extends StatelessWidget {
  const _TopicsBody({required this.state});

  final TopicsState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return switch (state) {
      TopicsLoading() => const Center(child: CircularProgressIndicator()),
      TopicsFailure() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.unexpectedError,
            style: TextStyle(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TopicsReady(:final topics) when topics.isEmpty => Center(
        child: Text(
          l10n.topicsEmpty,
          style: TextStyle(color: colors.textSecondary),
        ),
      ),
      TopicsReady(:final topics) => _TopicGroups(topics: topics),
    };
  }
}

class _TopicGroups extends StatelessWidget {
  const _TopicGroups({required this.topics});

  final List<Topic> topics;

  @override
  Widget build(BuildContext context) {
    final groups = groupTopicsByGrade(topics);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 24),
      children: [
        for (final (index, group) in groups.indexed) ...[
          _GradeHeader(grade: group.grade, isFirst: index == 0),
          for (final topic in group.topics) _TopicRow(topic: topic),
        ],
      ],
    );
  }
}

class _GradeHeader extends StatelessWidget {
  const _GradeHeader({required this.grade, required this.isFirst});

  final int grade;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 8 : 28, bottom: 4, right: 12),
      child: Text(
        l10n.topicGrade(grade),
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topicListSubtitle(l10n, topic),
                  style: TextStyle(color: colors.textSecondary, fontSize: 15),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.textSecondary),
        ],
      ),
    );
  }
}
