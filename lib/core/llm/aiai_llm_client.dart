import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/core/llm/llm_config.dart';

final class LlmReply {
  const LlmReply({required this.content, required this.model});

  final String content;
  final String model;
}

/// OpenAI-compatible chat client for aiai.by.
final class AiaiLlmClient {
  AiaiLlmClient(this._config, {Dio? dio}) : _dio = dio ?? Dio();

  final LlmConfig _config;
  final Dio _dio;

  Future<LlmReply> complete({
    required String system,
    required String user,
    int maxTokens = 8000,
  }) async {
    if (!_config.isConfigured) {
      throw const GenerationFailure(GenerationProblem.unavailable);
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${_config.baseUrl}/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_config.apiKey}',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 120),
        ),
        data: {
          'model': _config.model,
          'max_tokens': maxTokens,
          'messages': [
            {'role': 'system', 'content': system},
            {'role': 'user', 'content': user},
          ],
        },
      );
      return _reply(response.data);
    } on DioException catch (error, stackTrace) {
      log(
        'Generation request failed\n${error.response?.statusCode}\n${error.response?.data}\n$error\n$stackTrace',
        name: 'TaskGenerator',
        error: error,
        stackTrace: stackTrace,
      );
      throw _failure(error.response?.statusCode);
    }
  }

  LlmReply _reply(Map<String, dynamic>? json) {
    final content = _content(json);
    if (content == null || content.trim().isEmpty) {
      throw const GenerationFailure(GenerationProblem.empty);
    }
    final model = json?['model'];
    return LlmReply(
      content: content,
      model: model is String && model.isNotEmpty ? model : _config.model,
    );
  }

  String? _content(Map<String, dynamic>? json) {
    final choices = json?['choices'];
    if (choices is! List || choices.isEmpty) {
      return null;
    }
    final first = choices.first;
    if (first is! Map) {
      return null;
    }
    final message = first['message'];
    if (message is! Map) {
      return null;
    }
    final content = message['content'];
    return content is String ? content : null;
  }

  Failure _failure(int? statusCode) {
    return switch (statusCode) {
      401 || 403 => const GenerationFailure(GenerationProblem.rejected),
      402 => const GenerationFailure(GenerationProblem.quota),
      429 => const TooManyRequestsFailure(),
      null => const NetworkFailure(),
      _ => const UnexpectedFailure(),
    };
  }
}
