import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConstants {

  static final mapTilerApiKey = dotenv.get('MAPTILER_API_KEY');

  static const String mapTilerBaseUrl =
      'https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}.png';

  static const String mapUserAgentPackageName =
      'com.example.flower_app';
}