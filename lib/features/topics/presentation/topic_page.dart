import 'package:flutter/services.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/presentation/task_labels.dart';
import 'package:math_trainer_app/features/topics/presentation/task_pdf.dart';
import 'package:math_trainer_app/features/topics/presentation/widgets/task_card.dart';
import 'package:math_trainer_app/features/topics/presentation/widgets/topic_info_sheet.dart';
import 'package:math_trainer_app/features/topics/state/topic_practice_cubit.dart';
import 'package:printing/printing.dart';

class TopicPage extends StatelessWidget {
  const TopicPage({required this.topicId, super.key});

  final String? topicId;

  @override
  Widget build(BuildContext context) {
    final topicId = this.topicId;
    if (topicId == null || topicId.isEmpty) {
      return const _MissingTopicScaffold();
    }
    final userId = switch (context.read<AuthSessionCubit>().state) {
      AuthSessionSignedIn(:final user) => user.id,
      _ => '',
    };
    return BlocProvider(
      create: (_) => TopicPracticeCubit(
        topicId: topicId,
        userId: userId,
        topicsRepository: getIt<TopicsRepository>(),
        tasksRepository: getIt<TasksRepository>(),
        progressRepository: getIt<ProgressRepository>(),
        hideSolvedRepository: getIt<HideSolvedRepository>(),
      ),
      child: _TopicView(sectionsRepository: getIt<SectionsRepository>()),
    );
  }
}

class _TopicView extends StatelessWidget {
  const _TopicView({required this.sectionsRepository});

  final SectionsRepository sectionsRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicPracticeCubit, TopicPracticeState>(
      builder: (context, state) =>
          _TopicScaffold(state: state, sectionsRepository: sectionsRepository),
    );
  }
}

class _TopicScaffold extends StatelessWidget {
  const _TopicScaffold({required this.state, required this.sectionsRepository});

  final TopicPracticeState state;
  final SectionsRepository sectionsRepository;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = switch (state) {
      TopicPracticeReady(:final topic) => topic?.title ?? '',
      _ => '',
    };

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _TopicAppBar(
        title: title,
        state: state,
        sectionsRepository: sectionsRepository,
      ),
      body: _TopicBody(state: state),
    );
  }
}

class _TopicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopicAppBar({
    required this.title,
    required this.state,
    required this.sectionsRepository,
  });

  final String title;
  final TopicPracticeState state;
  final SectionsRepository sectionsRepository;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final ready = switch (state) {
      final TopicPracticeReady ready => ready,
      _ => null,
    };
    final topic = ready?.topic;

    return AppBar(
      toolbarHeight: 72,
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      surfaceTintColor: colors.background,
      elevation: 0,
      centerTitle: true,
      leading: const _BackButton(),
      title: Text(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          tooltip: l10n.printTasks,
          onPressed: ready == null || ready.topic == null
              ? null
              : () => _sharePdf(context, ready),
          icon: const Icon(Icons.picture_as_pdf_outlined),
        ),
        IconButton(
          tooltip: l10n.showTopic,
          onPressed: topic == null
              ? null
              : () => _showTopic(context, topic, sectionsRepository),
          icon: const Icon(Icons.menu_book_outlined),
        ),
      ],
    );
  }
}

class _TopicBody extends StatelessWidget {
  const _TopicBody({required this.state});

  final TopicPracticeState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return switch (state) {
      TopicPracticeLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
      TopicPracticeFailure() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.unexpectedError,
            style: TextStyle(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TopicPracticeReady(topic: null) => const _MissingTopic(),
      final TopicPracticeReady ready => _PracticeBody(state: ready),
    };
  }
}

class _PracticeBody extends StatelessWidget {
  const _PracticeBody({required this.state});

  final TopicPracticeReady state;

  @override
  Widget build(BuildContext context) {
    final tasks = state.visibleTasks;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _ProgressHeader(state: state),
        if (tasks.isEmpty)
          const _EmptyTasks()
        else
          for (final task in tasks) ...[
            TaskCard(task: task, solved: state.solvedIds.contains(task.id)),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.state});

  final TopicPracticeReady state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.solvedProgress(state.solvedCount, state.totalCount),
              style: TextStyle(color: colors.textPrimary, fontSize: 16),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              context.read<TopicPracticeCubit>().setHideSolved(
                !state.hideSolved,
              );
            },
            child: Text(state.hideSolved ? l10n.showSolved : l10n.hideSolved),
          ),
        ],
      ),
    );
  }
}

class _MissingTopicScaffold extends StatelessWidget {
  const _MissingTopicScaffold();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: colors.background,
        elevation: 0,
        leading: const _BackButton(),
      ),
      body: const _MissingTopic(),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}

class _MissingTopic extends StatelessWidget {
  const _MissingTopic();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          context.l10n.topicMissing,
          style: TextStyle(color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text(
        context.l10n.tasksEmpty,
        style: TextStyle(color: colors.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

Future<void> _sharePdf(BuildContext context, TopicPracticeReady state) async {
  final l10n = context.l10n;
  try {
    final font = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final bytes = await buildTasksPdf(
      fontBytes: font.buffer.asUint8List(
        font.offsetInBytes,
        font.lengthInBytes,
      ),
      title: state.topic?.title ?? l10n.topicsTab,
      tasks: [
        for (final task in state.visibleTasks)
          (caption: taskCaption(l10n, task), question: task.question),
      ],
    );
    await Printing.sharePdf(bytes: bytes, filename: 'tasks.pdf');
  } catch (_) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.printFailed)));
  }
}

void _showTopic(
  BuildContext context,
  Topic topic,
  SectionsRepository sectionsRepository,
) {
  final colors = context.colors;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    showDragHandle: true,
    builder: (context) =>
        TopicInfoSheet(topic: topic, sectionsRepository: sectionsRepository),
  );
}
