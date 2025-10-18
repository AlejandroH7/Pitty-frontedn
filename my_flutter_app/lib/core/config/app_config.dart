class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'BASE_API_URL',
    defaultValue: 'http://localhost:8080/api',
  );

  static const String apiUsername = String.fromEnvironment(
    'API_USERNAME',
    defaultValue: '',
  );

  static const String apiPassword = String.fromEnvironment(
    'API_PASSWORD',
    defaultValue: '',
  );

  static const String authPath = String.fromEnvironment(
    'API_AUTH_PATH',
    defaultValue: '/auth/login',
  );

  static const int httpTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: 15,
  );
}