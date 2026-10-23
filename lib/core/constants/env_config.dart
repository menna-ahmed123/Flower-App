import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? '';
  }

  static String get mapTilerApiKey {
    return dotenv.env['MAPTILER_API_KEY'] ?? '';
  }

  static String get osrmBaseUrl {
    return dotenv.env['OSRM_BASE_URL'] ?? 'https://router.project-osrm.org';
  }
}