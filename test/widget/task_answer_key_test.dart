import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/generation.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/presentation/topic_page.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('keeps an open answer on the task that revealed it', (
    tester,
  ) async {
    final progress = _Progress();
    final hideSolved = _HideSolved();
    getIt
      ..registerSingleton<TopicsRepository>(_Topics())
      ..registerSingleton<TasksRepository>(_Tasks())
      ..registerSingleton<ProgressRepository>(progress)
      ..registerSingleton<HideSolvedRepository>(hideSolved)
      ..registerSingleton<SectionsRepository>(_Sections())
      ..registerSingleton<TaskGenerator>(_Generator());
    addTearDown(getIt.reset);
    addTearDown(progress.close);
    addTearDown(hideSolved.close);

    final session = AuthSessionCubit(_SignedInAuth());
    addTearDown(session.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: session,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TopicPage(topicId: 'rule-1'),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Show answer').first);
    await tester.pump();
    expect(find.text('92'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    await tester.tap(find.text('Hide solved'));
    await tester.pump();

    expect(find.text('Compute (20 + 3) · 4'), findsNothing);
    expect(find.text('92'), findsNothing);
    expect(find.text('How many pencils?'), findsOneWidget);
    expect(find.text('144'), findsNothing);
    expect(find.text('Show answer'), findsOneWidget);
  });
}

class _SignedInAuth implements AuthRepository {
  @override
  Stream<AuthUser?> watchAuthState() {
    return Stream.value(const AuthUser(id: 'user-1', email: 'ada@example.com'));
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

class _Topics implements TopicsRepository {
  @override
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Topic>> watchTopics() {
    return Stream.value(const [
      Topic(
        id: 'rule-1',
        title: 'Distributive law',
        rule: 'Multiply each term.',
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
  }
}

class _Tasks implements TasksRepository {
  @override
  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  }) async {}

  @override
  Stream<List<Task>> watchTasks(String topicId) {
    return Stream.value(const [
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
  }
}

class _Progress implements ProgressRepository {
  final _values = BehaviorSubject<Set<String>>.seeded({});

  @override
  Stream<Set<String>> watchSolvedTaskIds(String userId) => _values.stream;

  @override
  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  }) async {
    final next = Set<String>.of(_values.value);
    if (solved) {
      next.add(taskId);
    } else {
      next.remove(taskId);
    }
    _values.add(next);
  }

  Future<void> close() => _values.close();
}

class _HideSolved implements HideSolvedRepository {
  final _values = BehaviorSubject<bool>.seeded(false);

  @override
  bool get hideSolved => _values.value;

  @override
  Stream<bool> watchHideSolved() => _values.stream;

  @override
  Future<void> setHideSolved(bool value) async {
    _values.add(value);
  }

  Future<void> close() => _values.close();
}

class _Sections implements SectionsRepository {
  @override
  Stream<String> watchSectionRule({
    required String bookId,
    required String sectionId,
  }) {
    return Stream.value('');
  }
}

class _Generator implements TaskGenerator {
  @override
  bool get isConfigured => false;

  @override
  Future<GenerationResult> generate(GenerationRequest request) {
    throw UnimplementedError();
  }
}
