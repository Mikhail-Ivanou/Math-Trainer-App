import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/matching.dart';
import 'package:math_trainer_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:math_trainer_app/features/catalog/presentation/widgets/catalog_rule_tile.dart';
import 'package:math_trainer_app/features/catalog/state/add_topic_cubit.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/domain/topic_similarity.dart';
import 'package:math_trainer_app/features/topics/presentation/generation_failure_message.dart';

class AddTopicPage extends StatelessWidget {
  const AddTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = switch (context.read<AuthSessionCubit>().state) {
      AuthSessionSignedIn(:final user) => user.id,
      _ => '',
    };
    return BlocProvider(
      create: (_) => AddTopicCubit(
        userId: userId,
        catalogRepository: getIt<CatalogRepository>(),
        topicsRepository: getIt<TopicsRepository>(),
        matcher: getIt<TopicMatcher>(),
      )..load(),
      child: const _AddTopicView(),
    );
  }
}

class _AddTopicView extends StatelessWidget {
  const _AddTopicView();

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
        title: Text(l10n.addTopicTitle),
      ),
      body: BlocBuilder<AddTopicCubit, AddTopicState>(
        builder: (context, state) => switch (state) {
          AddTopicLoading() => const Center(child: CircularProgressIndicator()),
          AddTopicFailure() => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.catalogFailed,
                style: TextStyle(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          final AddTopicReady ready => _AddTopicForm(state: ready),
        },
      ),
    );
  }
}

class _AddTopicForm extends StatefulWidget {
  const _AddTopicForm({required this.state});

  final AddTopicReady state;

  @override
  State<_AddTopicForm> createState() => _AddTopicFormState();
}

class _AddTopicFormState extends State<_AddTopicForm> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = widget.state;
    final busy = state.searching || state.loadingCatalog;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.addTopicGrade,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<int>(
            showSelectedIcon: false,
            selected: {state.grade},
            onSelectionChanged: busy
                ? null
                : (selection) {
                    context.read<AddTopicCubit>().selectGrade(selection.first);
                  },
            segments: [
              for (final grade in state.grades)
                ButtonSegment(value: grade, label: Text('$grade')),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _query,
          minLines: 1,
          maxLines: 3,
          maxLength: 500,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            labelText: l10n.addTopicPrompt,
            hintText: l10n.addTopicHint,
            suffixIcon: IconButton(
              onPressed: busy ? null : _search,
              icon: const Icon(Icons.search),
            ),
          ),
        ),
        if (busy) const LinearProgressIndicator(),
        if (state.failure case final Failure failure)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              generationFailureMessage(l10n, failure),
              style: TextStyle(color: colors.danger),
            ),
          ),
        if (state.matches != null) ...[
          const SizedBox(height: 12),
          Text(
            state.matches?.isEmpty ?? true
                ? l10n.addTopicNone(state.grade)
                : l10n.addTopicFound,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          for (final match in state.matches ?? const <TopicMatch>[])
            CatalogRuleTile(
              rule: match.rule,
              why: match.why,
              added: state.contains(match.rule.id),
              similar: _similar(state, match.rule) != null,
              onTap: () => _add(match.rule),
            ),
        ],
        if (!state.loadingCatalog) ...[
          const SizedBox(height: 16),
          Text(
            l10n.addTopicBrowse,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          ..._browse(state),
        ],
      ],
    );
  }

  List<Widget> _browse(AddTopicReady state) {
    final byBook = <String, Map<String, List<CatalogRule>>>{};
    for (final rule in state.catalog) {
      final section = '§ ${rule.sectionNumber}. ${rule.sectionTitle}';
      byBook
          .putIfAbsent(rule.bookTitle, () => {})
          .putIfAbsent(section, () => [])
          .add(rule);
    }
    return [
      for (final book in byBook.entries)
        ExpansionTile(
          key: PageStorageKey('book:${state.grade}:${book.key}'),
          tilePadding: EdgeInsets.zero,
          title: Text(book.key),
          children: [
            for (final section in book.value.entries)
              ExpansionTile(
                key: PageStorageKey('section:${state.grade}:${section.key}'),
                tilePadding: const EdgeInsets.only(left: 12),
                childrenPadding: const EdgeInsets.only(left: 12),
                title: Text(section.key),
                children: [
                  for (final rule in section.value)
                    CatalogRuleTile(
                      rule: rule,
                      showSource: false,
                      added: state.contains(rule.id),
                      similar: _similar(state, rule) != null,
                      onTap: () => _add(rule),
                    ),
                ],
              ),
          ],
        ),
    ];
  }

  Topic? _similar(AddTopicReady state, CatalogRule rule) {
    if (state.contains(rule.id)) {
      return null;
    }
    return similarTopic(rule: rule, grade: state.grade, topics: state.topics);
  }

  Future<void> _search() {
    return context.read<AddTopicCubit>().search(_query.text);
  }

  Future<void> _add(CatalogRule rule) async {
    final state = widget.state;
    final similar = _similar(state, rule);
    if (similar != null) {
      final choice = await _confirmSimilar(rule, similar);
      if (!mounted || choice == null) {
        return;
      }
      if (choice == 'open') {
        Navigator.of(context).pop(similar.id);
        return;
      }
    }
    try {
      final topic = await context.read<AddTopicCubit>().add(rule, _query.text);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(topic.id);
    } on Failure {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.addTopicFailed)));
    }
  }

  Future<String?> _confirmSimilar(CatalogRule rule, Topic similar) {
    final l10n = context.l10n;
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addTopicSimilarTitle),
        content: Text(
          l10n.addTopicSimilarBody(
            similar.title,
            similar.source,
            rule.sectionNumber,
            rule.sectionTitle,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('add'),
            child: Text(l10n.addTopicAddThis),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop('open'),
            child: Text(l10n.addTopicOpenExisting),
          ),
        ],
      ),
    );
  }
}
