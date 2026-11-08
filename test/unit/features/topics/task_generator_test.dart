import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/topics/data/generation/task_generator_impl.dart';
import 'package:math_trainer_app/core/llm/aiai_llm_client.dart';
import 'package:math_trainer_app/core/llm/llm_config.dart';
import 'package:math_trainer_app/features/topics/domain/entities/task.dart';
import 'package:math_trainer_app/features/topics/domain/generation.dart';

void main() {
  const config = LlmConfig(
    apiKey: 'key',
    model: 'configured-model',
    baseUrl: 'https://example.test/v1',
  );
  const request = GenerationRequest(
    topicTitle: 'Distributive law',
    rule: 'Multiply each term.',
    grade: 5,
    subject: 'math',
    level: Difficulty.hard,
  );

  test('keeps a verified task and counts a wrong answer', () async {
    final generator = TaskGeneratorImpl.client(
      config,
      AiaiLlmClient(config, dio: _dio(_reply(_sampleTasks))),
    );

    final result = await generator.generate(request);

    expect(result.tasks, hasLength(1));
    expect(result.tasks.single.answer, '4');
    expect(result.tasks.single.difficulty, Difficulty.hard);
    expect(result.rejectedCount, 1);
    expect(result.model, 'reply-model');
  });

  test('refuses to call the model without a key', () async {
    const empty = LlmConfig(apiKey: '', model: 'm', baseUrl: 'https://x');
    final generator = TaskGeneratorImpl.client(empty, AiaiLlmClient(empty));

    expect(generator.isConfigured, isFalse);
    expect(
      generator.generate(request),
      throwsA(
        isA<GenerationFailure>().having(
          (failure) => failure.problem,
          'problem',
          GenerationProblem.unavailable,
        ),
      ),
    );
  });

  test('maps HTTP 402 to a quota failure', () async {
    final generator = TaskGeneratorImpl.client(
      config,
      AiaiLlmClient(config, dio: _dio('{}', statusCode: 402)),
    );

    expect(
      generator.generate(request),
      throwsA(
        isA<GenerationFailure>().having(
          (failure) => failure.problem,
          'problem',
          GenerationProblem.quota,
        ),
      ),
    );
  });

  test('sizes a math batch and a geometry batch', () {
    expect(batchCounts('math', Difficulty.medium), {
      TaskType.expression: 3,
      TaskType.equation: 2,
      TaskType.word: 3,
    });
    expect(batchCounts('geometry', Difficulty.expert), {TaskType.word: 6});
    expect(
      batchCounts('algebra', Difficulty.medium).keys,
      contains(TaskType.simplify),
    );
  });
}

const _sampleTasks = '''
Here are the tasks:
{"tasks":[
  {"type":"expression","question":"Compute 2 + 2","expr":"2+2","answer":"4"},
  {"type":"expression","question":"Compute 2 + 2","expr":"2+2","answer":"5"}
]}
''';

String _reply(String content) {
  return jsonEncode({
    'model': 'reply-model',
    'choices': [
      {
        'message': {'content': content},
      },
    ],
  });
}

Dio _dio(String body, {int statusCode = 200}) {
  final dio = Dio();
  dio.httpClientAdapter = _Adapter(body, statusCode);
  return dio;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, this.statusCode);

  final String body;
  final int statusCode;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
