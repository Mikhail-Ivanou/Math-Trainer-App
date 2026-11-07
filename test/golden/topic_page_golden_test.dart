import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/core/ui_kit/theme/app_theme.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/presentation/topic_page.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

void main() {
  setUpAll(() {
    getIt
      ..registerSingleton<TopicsRepository>(_TopicsRepository())
      ..registerSingleton<TasksRepository>(_TasksRepository())
      ..registerSingleton<ProgressRepository>(_ProgressRepository())
      ..registerSingleton<HideSolvedRepository>(_HiddenSolvedOff())
      ..registerSingleton<SectionsRepository>(_SectionsRepository());
  });

  tearDownAll(getIt.reset);

  goldenTest(
    'topic page in light and dark themes',
    fileName: 'topic_page',
    constraints: const BoxConstraints.tightFor(width: 800, height: 900),
    builder: () => GoldenTestGroup(
      columns: 2,
      columnWidthBuilder: (_) => const FixedColumnWidth(360),
      scenarioConstraints: const BoxConstraints.tightFor(
        width: 360,
        height: 780,
      ),
      children: [
        GoldenTestScenario(
          name: 'light',
          child: _TopicHost(theme: AppTheme.light),
        ),
        GoldenTestScenario(
          name: 'dark',
          child: _TopicHost(theme: AppTheme.dark),
        ),
      ],
    ),
  );
}

class _TopicHost extends StatelessWidget {
  const _TopicHost({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthSessionCubit(_SignedInRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TopicPage(topicId: 'rule-1'),
      ),
    );
  }
}

class _SignedInRepository implements AuthRepository {
  @override
  Stream<AuthUser?> watchAuthState() {
    return Stream<AuthUser?>.multi((controller) {
      controller.add(const AuthUser(id: 'user-1', email: 'ada@example.com'));
    });
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}
}

class _HiddenSolvedOff implements HideSolvedRepository {
  @override
  bool get hideSolved => false;

  @override
  Stream<bool> watchHideSolved() => Stream.value(false);

  @override
  Future<void> setHideSolved(bool value) async {}
}

class _TopicsRepository implements TopicsRepository {
  @override
  Stream<List<Topic>> watchTopics() {
    return Stream<List<Topic>>.multi((controller) {
      controller.add(const [
        Topic(
          id: 'rule-1',
          title: 'Distributive law',
          rule: 'Multiply each term.',
          paragraph: 'The full paragraph.',
          grade: 5,
          subject: 'math',
          bookId: 'book-1',
          bookTitle: 'Algebra',
          chapter: 1,
          chapterTitle: 'Numbers',
          sectionId: 'section-9',
          sectionNumber: 9,
          sectionTitle: 'Natural numbers',
        ),
      ]);
    });
  }
}

class _TasksRepository implements TasksRepository {
  @override
  Stream<List<Task>> watchTasks(String topicId) {
    return Stream<List<Task>>.multi((controller) {
      controller.add(const [
        Task(
          id: 'solved',
          type: TaskType.expression,
          difficulty: Difficulty.easy,
          question: 'Compute (20 + 3) · 4',
          answer: '92',
        ),
        Task(
          id: 'open',
          type: TaskType.word,
          difficulty: Difficulty.medium,
          question: 'How many pencils?',
          answer: '144',
        ),
      ]);
    });
  }
}

class _ProgressRepository implements ProgressRepository {
  @override
  Stream<Set<String>> watchSolvedTaskIds(String userId) {
    return Stream<Set<String>>.multi((controller) {
      controller.add({'solved'});
    });
  }

  @override
  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  }) async {}
}

class _SectionsRepository implements SectionsRepository {
  @override
  Stream<String> watchSectionRule({
    required String bookId,
    required String sectionId,
  }) {
    return Stream.value('');
  }
}
