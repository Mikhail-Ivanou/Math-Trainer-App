import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/llm/llm_config.dart';

void main() {
  test('uses a supplied key and fills missing model settings', () {
    final config = llmConfigFromDefines(
      apiKey: 'from-define',
      model: '',
      baseUrl: '',
    );

    expect(config.apiKey, 'from-define');
    expect(config.model, 'claude-haiku-5.5');
    expect(config.baseUrl, 'https://api.aiai.by/v1');
    expect(config.isConfigured, isTrue);
  });

  test('an empty key is not configured', () {
    final config = llmConfigFromDefines(
      apiKey: '',
      model: 'file-model',
      baseUrl: 'https://example.test/v1',
    );

    expect(config.isConfigured, isFalse);
    expect(config.model, 'file-model');
    expect(config.baseUrl, 'https://example.test/v1');
  });
}
