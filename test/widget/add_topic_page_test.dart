import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/di/injection.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';
import 'package:math_trainer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:math_trainer_app/features/auth/state/auth_session_cubit.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/matching.dart';
import 'package:math_trainer_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';
import 'package:math_trainer_app/features/catalog/presentation/add_topic_page.dart';
import 'package:math_trainer_app/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('adds the textbook rule the student picks', (tester) async {
    final topics = _TopicsRepository();
    getIt
      ..registerSingleton<CatalogRepository>(_CatalogRepository())
      ..registerSingleton<TopicsRepository>(topics)
      ..registerSingleton<TopicMatcher>(const _UnconfiguredMatcher());
    addTearDown(getIt.reset);

    final session = AuthSessionCubit(_SignedInAuth());
    addTearDown(session.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: session,
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AddTopicPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'distributive law');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Distributive law'), findsOneWidget);

    await tester.tap(find.text('Distributive law'));
    await tester.pumpAndSettle();

    expect(topics.addedId, 'rule-1');
    expect(topics.reason, 'distributive law');
  });
}

class _SignedInAuth implements AuthRepository {
  @override
  Stream<AuthUser?> watchAuthState() => Stream.value(
    const AuthUser(id: 'student-1', email: 'student@example.com'),
  );

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

class _CatalogRepository implements CatalogRepository {
  @override
  Future<List<int>> grades() async => const [5];

  @override
  Future<List<CatalogRule>> catalog(int grade) async => const [
    CatalogRule(
      id: 'rule-1',
      title: 'Distributive law',
      bookId: 'book-1',
      bookTitle: 'Algebra',
      subject: 'math',
      chapterTitle: 'Numbers',
      sectionId: 'section-1',
      sectionNumber: 9,
      sectionTitle: 'Natural numbers',
      keywords: ['distributive'],
    ),
  ];

  @override
  Future<int?> rememberedGrade(String userId) async => null;

  @override
  Future<void> rememberGrade(String userId, int grade) async {}
}

class _TopicsRepository implements TopicsRepository {
  String? addedId;
  String? reason;

  @override
  Future<Topic> addTopic({
    required CatalogRule rule,
    required String userId,
    required String reason,
  }) async {
    addedId = rule.id;
    this.reason = reason;
    return Topic(
      id: rule.id,
      title: rule.title,
      rule: 'Multiply each term.',
      grade: 5,
      subject: rule.subject,
      bookId: rule.bookId,
      bookTitle: rule.bookTitle,
      chapter: 1,
      chapterTitle: rule.chapterTitle,
      sectionId: rule.sectionId,
      sectionNumber: rule.sectionNumber,
      sectionTitle: rule.sectionTitle,
    );
  }

  @override
  Stream<List<Topic>> watchTopics() => Stream.value(const []);
}

class _UnconfiguredMatcher implements TopicMatcher {
  const _UnconfiguredMatcher();

  @override
  bool get isConfigured => false;

  @override
  Future<List<TopicMatch>> match({
    required String request,
    required List<CatalogRule> catalog,
  }) {
    throw UnimplementedError();
  }
}
