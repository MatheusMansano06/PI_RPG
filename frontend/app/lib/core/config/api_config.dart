import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _defaultLanBaseUrl = 'http://172.16.235.55:3000';
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultLanBaseUrl,
  );
  static const bool useBackendLocationCheck = bool.fromEnvironment(
    'USE_BACKEND_LOCATION_CHECK',
    defaultValue: true,
  );

  static String get runtimeBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      if (baseUrl.contains('localhost')) {
        return baseUrl.replaceFirst('localhost', '10.0.2.2');
      }
    }
    return baseUrl;
  }
}
