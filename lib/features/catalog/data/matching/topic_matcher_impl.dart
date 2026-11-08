import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/llm/aiai_llm_client.dart';
import 'package:math_trainer_app/core/llm/llm_config.dart';
import 'package:math_trainer_app/features/catalog/domain/entities/catalog_rule.dart';
import 'package:math_trainer_app/features/catalog/domain/matching.dart';

@LazySingleton(as: TopicMatcher)
final class TopicMatcherImpl implements TopicMatcher {
  @factoryMethod
  factory TopicMatcherImpl() => TopicMatcherImpl._(loadLlmConfig());

  TopicMatcherImpl._(LlmConfig config)
    : _config = config,
      _client = AiaiLlmClient(config);

  TopicMatcherImpl.client(this._config, this._client);

  final LlmConfig _config;
  final AiaiLlmClient _client;

  @override
  bool get isConfigured => _config.isConfigured;

  @override
  Future<List<TopicMatch>> match({
    required String request,
    required List<CatalogRule> catalog,
  }) async {
    if (catalog.isEmpty) {
      return const [];
    }
    final reply = await _client.complete(
      maxTokens: 1500,
      system:
          'Ты помогаешь школьнику найти в учебниках конкретное правило, которое ему трудно даётся. '
          'Выбирай только из списка правил. Верни только JSON.',
      user: _prompt(request, catalog),
    );
    return parseTopicMatches(reply.content, catalog);
  }
}

List<TopicMatch> parseTopicMatches(String content, List<CatalogRule> catalog) {
  final start = content.indexOf('{');
  final end = content.lastIndexOf('}');
  if (start < 0 || end <= start) {
    throw const GenerationFailure(GenerationProblem.empty);
  }
  final Object? decoded;
  try {
    decoded = jsonDecode(content.substring(start, end + 1));
  } on FormatException {
    throw const GenerationFailure(GenerationProblem.empty);
  }
  if (decoded is! Map) {
    return const [];
  }
  final matches = decoded['matches'];
  if (matches is! List) {
    return const [];
  }
  final byId = {for (final rule in catalog) rule.id: rule};
  final seen = <String>{};
  final result = <TopicMatch>[];
  for (final match in matches) {
    if (match is! Map) {
      continue;
    }
    final id = match['id'];
    if (id is! String || !seen.add(id)) {
      continue;
    }
    final rule = byId[id];
    if (rule == null) {
      continue;
    }
    final why = match['why'];
    result.add(TopicMatch(rule: rule, why: why is String ? why.trim() : ''));
    if (result.length == 4) {
      break;
    }
  }
  return result;
}

String _prompt(String request, List<CatalogRule> catalog) {
  final lines = StringBuffer();
  String? section;
  for (final rule in catalog) {
    final heading =
        '${rule.bookTitle}, § ${rule.sectionNumber}. ${rule.sectionTitle}';
    if (heading != section) {
      lines.writeln('# $heading');
    }
    section = heading;
    lines.writeln('${rule.id} | ${rule.title} | ${rule.keywords.join(', ')}');
  }
  return '''
Ученик написал: «$request»

Правила из учебников по параграфам (id | правило | ключевые слова):
$lines
Выбери до 4 правил, которые лучше всего подходят под запрос, самое подходящее первым. Предпочитай конкретное правило, а не общее. Если ничего не подходит, верни пустой список.
Формат: {"matches": [{"id": "…", "why": "коротко, почему подходит"}]}''';
}
