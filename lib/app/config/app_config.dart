enum Environment { development, staging, production }

class AppConfig {
  AppConfig._();

  static AppConfig? _instance;
  static AppConfig get instance {
    assert(_instance != null, 'AppConfig must be initialized first.');
    return _instance!;
  }

  late final Environment environment;
  late final String baseUrl;
  late final int apiTimeout;
  late final bool enableLogging;

  static void initialize({
    required Environment environment,
    required String baseUrl,
    required int apiTimeout,
    required bool enableLogging,
  }) {
    _instance = AppConfig._()
      ..environment = environment
      ..baseUrl = baseUrl
      ..apiTimeout = apiTimeout
      ..enableLogging = enableLogging;
  }

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;
}
