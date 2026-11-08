/// Settings for the textbook model, baked in at compile time.
///
/// `flutter run --dart-define-from-file=.env` reads `.env` while compiling.
/// A `--dart-define` with the same name overrides that file. `.env` stays
/// out of git.
final class LlmConfig {
  const LlmConfig({
    required this.apiKey,
    required this.model,
    required this.baseUrl,
  });

  final String apiKey;
  final String model;
  final String baseUrl;

  bool get isConfigured => apiKey.isNotEmpty;

  static const defaultModel = 'claude-haiku-5.5';
  static const defaultBaseUrl = 'https://api.aiai.by/v1';
}

/// Values the compiler supplied. An empty model or base URL keeps the default.
LlmConfig llmConfigFromDefines({
  required String apiKey,
  required String model,
  required String baseUrl,
}) {
  return LlmConfig(
    apiKey: apiKey,
    model: model.isEmpty ? LlmConfig.defaultModel : model,
    baseUrl: baseUrl.isEmpty ? LlmConfig.defaultBaseUrl : baseUrl,
  );
}

LlmConfig loadLlmConfig() {
  return llmConfigFromDefines(
    apiKey: const String.fromEnvironment('AIAI_API_KEY'),
    model: const String.fromEnvironment('AIAI_MODEL'),
    baseUrl: const String.fromEnvironment('AIAI_BASE_URL'),
  );
}
