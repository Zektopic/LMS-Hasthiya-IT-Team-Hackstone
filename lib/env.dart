abstract class Env {
  static const String lmsBaseUrl = String.fromEnvironment(
    'LMS_BASE_URL',
    defaultValue: 'https://localhost:5000',
  );
}
