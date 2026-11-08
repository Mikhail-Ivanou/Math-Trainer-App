import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/generation.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/progress_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/tasks_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/sections_repository.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/topics/presentation/topic_page.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows tasks, hides solved ones, and opens the topic sheet', (
    tester,
  ) async {
    final hideSolved = _HideSolvedRepository();
    final progress = _ProgressRepository();
    getIt
      ..registerSingleton<TopicsRepository>(_TopicsRepository())
      ..registerSingleton<TasksRepository>(_TasksRepository())
      ..registerSingleton<ProgressRepository>(progress)
      ..registerSingleton<HideSolvedRepository>(hideSolved)
      ..registerSingleton<SectionsRepository>(_SectionsRepository())
      ..registerSingleton<TaskGenerator>(const _UnconfiguredGenerator());
    addTearDown(getIt.reset);
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

    expect(find.text('Distributive law'), findsOneWidget);
    expect(find.text('Solved 1 of 2'), findsOneWidget);
    expect(find.text('Hide solved'), findsOneWidget);
    expect(
      tester.getBottomLeft(find.text('Solved 1 of 2')).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.byType(ListView)).dy),
    );
    expect(find.text('Compute (20 + 3) · 4'), findsOneWidget);
    expect(find.text('How many pencils?'), findsOneWidget);

    await tester.tap(find.text('Show answer').last);
    await tester.pump();
    expect(find.text('144'), findsOneWidget);

    await tester.tap(find.text('Hide solved'));
    await tester.pump();
    expect(find.text('Compute (20 + 3) · 4'), findsNothing);
    expect(find.text('Show solved'), findsOneWidget);
    expect(find.text('Solved 1 of 2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Multiply each term.'), findsOneWidget);
    expect(
      find.text('Math. Grade 5. Part 1 · § 9. Natural numbers'),
      findsOneWidget,
    );

    await tester.tap(find.text('Whole paragraph'));
    await tester.pump();
    await tester.pump();
    expect(find.text('The full paragraph.'), findsOneWidget);

    Navigator.of(tester.element(find.text('Whole paragraph'))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(progress.solvedTaskId, 'open');
  });

  testWidgets('shows that the topic is missing when the id is absent', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TopicPage(topicId: null),
      ),
    );

    expect(find.text('This topic is unavailable.'), findsOneWidget);
    expect(find.text('Solved 1 of 2'), findsNothing);
  });

  testWidgets('shows that the topic is missing when the id is unknown', (
    tester,
  ) async {
    final hideSolved = _HideSolvedRepository();
    getIt
      ..registerSingleton<TopicsRepository>(_TopicsRepository())
      ..registerSingleton<TasksRepository>(_TasksRepository())
      ..registerSingleton<ProgressRepository>(_ProgressRepository())
      ..registerSingleton<HideSolvedRepository>(hideSolved)
      ..registerSingleton<SectionsRepository>(_SectionsRepository())
      ..registerSingleton<TaskGenerator>(const _UnconfiguredGenerator());
    addTearDown(getIt.reset);
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
          home: TopicPage(topicId: 'missing'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('This topic is unavailable.'), findsOneWidget);
    expect(find.text('How many pencils?'), findsNothing);
    expect(find.text('Solved 1 of 2'), findsNothing);
  });

  testWidgets('keeps the topic sheet within 90% of the screen', (tester) async {
    final hideSolved = _HideSolvedRepository();
    getIt
      ..registerSingleton<TopicsRepository>(_TopicsRepository())
      ..registerSingleton<TasksRepository>(_TasksRepository())
      ..registerSingleton<ProgressRepository>(_ProgressRepository())
      ..registerSingleton<HideSolvedRepository>(hideSolved)
      ..registerSingleton<SectionsRepository>(
        _SectionsRepository(rule: 'Theory. ' * 400),
      )
      ..registerSingleton<TaskGenerator>(const _UnconfiguredGenerator());
    addTearDown(getIt.reset);
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

    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Whole paragraph'));
    await tester.pump();
    await tester.pump();

    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      tester.getSize(find.byType(BottomSheet)).height,
      lessThanOrEqualTo(screenHeight * 0.9),
    );
  });

  testWidgets('asks for a level and saves the generated tasks', (tester) async {
    final hideSolved = _HideSolvedRepository();
    final tasks = _SavingTasks();
    final generator = _RecordingGenerator();
    getIt
      ..registerSingleton<TopicsRepository>(_TopicsRepository())
      ..registerSingleton<TasksRepository>(tasks)
      ..registerSingleton<ProgressRepository>(_ProgressRepository())
      ..registerSingleton<HideSolvedRepository>(hideSolved)
      ..registerSingleton<SectionsRepository>(_SectionsRepository())
      ..registerSingleton<TaskGenerator>(generator);
    addTearDown(getIt.reset);
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
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Problem level'), findsOneWidget);

    await tester.tap(find.text('Create problems'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Added 1 problems.'), findsOneWidget);
    expect(generator.level, Difficulty.medium);
    expect(tasks.saved, hasLength(1));
    expect(tasks.userId, 'user-1');
    expect(tasks.model, 'test-model');
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

class _TopicsRepository implements TopicsRepository {
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

class _TasksRepository implements TasksRepository {
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

class _ProgressRepository implements ProgressRepository {
  String? solvedTaskId;

  @override
  Stream<Set<String>> watchSolvedTaskIds(String userId) {
    return Stream.value({'solved'});
  }

  @override
  Future<void> setSolved({
    required String userId,
    required String topicId,
    required String taskId,
    required bool solved,
  }) async {
    solvedTaskId = taskId;
  }
}

class _HideSolvedRepository implements HideSolvedRepository {
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

class _SavingTasks implements TasksRepository {
  List<Task> saved = const [];
  String? userId;
  String? model;

  @override
  Future<void> addGeneratedTasks({
    required String topicId,
    required List<Task> tasks,
    required String userId,
    required String model,
  }) async {
    saved = tasks;
    this.userId = userId;
    this.model = model;
  }

  @override
  Stream<List<Task>> watchTasks(String topicId) => Stream.value(const []);
}

class _RecordingGenerator implements TaskGenerator {
  Difficulty? level;

  @override
  bool get isConfigured => true;

  @override
  Future<GenerationResult> generate(GenerationRequest request) async {
    level = request.level;
    return GenerationResult(
      tasks: [
        Task(
          id: '',
          type: TaskType.expression,
          difficulty: request.level,
          question: 'Compute 2 + 2',
          answer: '4',
          expr: '2+2',
        ),
      ],
      rejectedCount: 0,
      model: 'test-model',
    );
  }
}

class _UnconfiguredGenerator implements TaskGenerator {
  const _UnconfiguredGenerator();

  @override
  bool get isConfigured => false;

  @override
  Future<GenerationResult> generate(GenerationRequest request) {
    throw UnimplementedError();
  }
}

class _SectionsRepository implements SectionsRepository {
  _SectionsRepository({this.rule = 'The full paragraph.'});

  final String rule;

  @override
  Stream<String> watchSectionRule({
    required String bookId,
    required String sectionId,
  }) {
    return Stream.value(rule);
  }
}
