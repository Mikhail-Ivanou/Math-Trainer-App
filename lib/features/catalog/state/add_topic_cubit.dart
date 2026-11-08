import 'package:equatable/equatable.dart';
import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/matching.dart';
import 'package:math_trainer_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:math_trainer_app/features/topics/domain/entities/topic.dart';
import 'package:math_trainer_app/features/topics/domain/repositories/topics_repository.dart';

sealed class AddTopicState extends Equatable {
  const AddTopicState();
}

final class AddTopicLoading extends AddTopicState {
  const AddTopicLoading();

  @override
  List<Object?> get props => const [];
}

final class AddTopicFailure extends AddTopicState {
  const AddTopicFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class AddTopicReady extends AddTopicState {
  const AddTopicReady({
    required this.grades,
    required this.grade,
    required this.catalog,
    required this.topics,
    this.matches,
    this.loadingCatalog = false,
    this.searching = false,
    this.failure,
  });

  final List<int> grades;
  final int grade;
  final List<CatalogRule> catalog;
  final List<Topic> topics;
  final List<TopicMatch>? matches;
  final bool loadingCatalog;
  final bool searching;
  final Failure? failure;

  bool contains(String ruleId) {
    for (final topic in topics) {
      if (topic.id == ruleId) {
        return true;
      }
    }
    return false;
  }

  AddTopicReady copyWith({
    int? grade,
    List<CatalogRule>? catalog,
    bool? loadingCatalog,
    bool? searching,
    List<TopicMatch>? matches,
    bool clearMatches = false,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return AddTopicReady(
      grades: grades,
      grade: grade ?? this.grade,
      catalog: catalog ?? this.catalog,
      topics: topics,
      matches: clearMatches ? null : matches ?? this.matches,
      loadingCatalog: loadingCatalog ?? this.loadingCatalog,
      searching: searching ?? this.searching,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    grades,
    grade,
    catalog,
    topics,
    matches,
    loadingCatalog,
    searching,
    failure,
  ];
}

class AddTopicCubit extends Cubit<AddTopicState> {
  AddTopicCubit({
    required this.userId,
    required this._catalogRepository,
    required this._topicsRepository,
    required this._matcher,
  }) : super(const AddTopicLoading());

  final String userId;
  final CatalogRepository _catalogRepository;
  final TopicsRepository _topicsRepository;
  final TopicMatcher _matcher;

  Future<void> load() async {
    emit(const AddTopicLoading());
    try {
      final grades = await _catalogRepository.grades();
      final available = grades.isEmpty ? const [5] : grades;
      final remembered = await _catalogRepository.rememberedGrade(userId);
      final selected = available.contains(remembered)
          ? remembered
          : available.first;
      await _loadGrade(available, selected ?? available.first);
    } on Failure catch (failure) {
      emit(AddTopicFailure(failure));
    } catch (_) {
      emit(const AddTopicFailure(UnexpectedFailure()));
    }
  }

  Future<void> selectGrade(int grade) async {
    final current = state;
    if (current is! AddTopicReady || current.grade == grade) {
      return;
    }
    emit(
      current.copyWith(
        grade: grade,
        loadingCatalog: true,
        clearMatches: true,
        clearFailure: true,
      ),
    );
    try {
      await _loadGrade(current.grades, grade);
    } on Failure catch (failure) {
      emit(AddTopicFailure(failure));
    } catch (_) {
      emit(const AddTopicFailure(UnexpectedFailure()));
    }
  }

  Future<void> search(String query) async {
    final current = state;
    final text = query.trim();
    if (current is! AddTopicReady || text.isEmpty || current.searching) {
      return;
    }
    emit(current.copyWith(searching: true, clearFailure: true));
    try {
      final matches = _matcher.isConfigured
          ? await _matcher.match(request: text, catalog: current.catalog)
          : [
              for (final rule in filterCatalog(text, current.catalog).take(3))
                TopicMatch(rule: rule),
            ];
      final latest = state;
      if (latest is! AddTopicReady) {
        return;
      }
      emit(latest.copyWith(matches: matches, searching: false));
    } on Failure catch (failure) {
      final latest = state;
      if (latest is! AddTopicReady) {
        return;
      }
      emit(latest.copyWith(searching: false, failure: failure));
    } catch (_) {
      final latest = state;
      if (latest is! AddTopicReady) {
        return;
      }
      emit(
        latest.copyWith(searching: false, failure: const UnexpectedFailure()),
      );
    }
  }

  Future<Topic> add(CatalogRule rule, String reason) async {
    final current = state;
    if (current is AddTopicReady) {
      emit(current.copyWith(searching: true, clearFailure: true));
    }
    try {
      final topic = await _topicsRepository.addTopic(
        rule: rule,
        userId: userId,
        reason: reason,
      );
      final grade = switch (state) {
        AddTopicReady(:final grade) => grade,
        _ => null,
      };
      if (grade != null) {
        try {
          await _catalogRepository.rememberGrade(userId, grade);
        } on Failure {
          // The topic is already saved. The next visit can use another grade.
        }
      }
      return topic;
    } on Failure {
      _stopSearching();
      rethrow;
    } catch (_) {
      _stopSearching();
      throw const UnexpectedFailure();
    }
  }

  Future<void> _loadGrade(List<int> grades, int grade) async {
    final catalogFuture = _catalogRepository.catalog(grade);
    final topicsFuture = _topicsRepository.watchTopics().first;
    emit(
      AddTopicReady(
        grades: grades,
        grade: grade,
        catalog: await catalogFuture,
        topics: await topicsFuture,
      ),
    );
  }

  void _stopSearching() {
    final current = state;
    if (current is AddTopicReady) {
      emit(current.copyWith(searching: false));
    }
  }
}
