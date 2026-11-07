import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/presentation/topic_citation.dart';
import 'package:math_trainer_app/features/topics/state/section_theory_cubit.dart';

class TopicInfoSheet extends StatelessWidget {
  const TopicInfoSheet({
    required this.topic,
    required this.sectionsRepository,
    super.key,
  });

  final Topic topic;
  final SectionsRepository sectionsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => SectionTheoryCubit(
        repository: sectionsRepository,
        bookId: topic.bookId,
        sectionId: topic.sectionId,
      ),
      child: _TopicInfoBody(topic: topic),
    );
  }
}

class _TopicInfoBody extends StatefulWidget {
  const _TopicInfoBody({required this.topic});

  final Topic topic;

  @override
  State<_TopicInfoBody> createState() => _TopicInfoBodyState();
}

class _TopicInfoBodyState extends State<_TopicInfoBody> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final topic = widget.topic;
    final maxHeight =
        MediaQuery.sizeOf(context).height * 0.9 - kMinInteractiveDimension;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight < 0 ? 0 : maxHeight),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic.title,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                topicCitation(l10n, topic),
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              if (topic.rule.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  topic.rule,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 18,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.wholeParagraph,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_expanded) const _SectionTheory(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTheory extends StatelessWidget {
  const _SectionTheory();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = TextStyle(
      color: colors.textPrimary,
      fontSize: 18,
      height: 1.4,
    );

    return BlocBuilder<SectionTheoryCubit, SectionTheoryState>(
      builder: (context, state) {
        return switch (state) {
          SectionTheoryLoading() => const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          SectionTheoryFailure() => Text(
            context.l10n.unexpectedError,
            style: style,
          ),
          SectionTheoryReady(:final rule) when rule.isEmpty =>
            const SizedBox.shrink(),
          SectionTheoryReady(:final rule) => Text(rule, style: style),
        };
      },
    );
  }
}
