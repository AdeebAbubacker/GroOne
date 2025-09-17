import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gro_one_app/data/network/env/environment_controller.dart';

class EnvironmentVariables {
  /// Fetch Base URL
  static String get fetchBaseUrl {
    return _getEnvVariable("API_BASE_URL");
  }

  /// Fetch Base URL
  static String get fetchMapKey {
    return _getEnvVariable("MAP_KEY");
  }

  /// Fetch Base URL
  static String get groServiceUrl {
    return _getEnvVariable("VITE_VERIFICATION_BASE_URL");

  }
  /// Fetch Base URL
  static String get adminURL {
    return _getEnvVariable("ADMIN_URL");

  }

  /// Fetch X API KEY
  static String get fetchXApiKEY {
    return _getEnvVariable("X_API_KEY");
  }

  /// Fetch X API KEY
  static String get fetchChatBotXApiKEY {
    return _getEnvVariable("CHATBOT_X_API_KEY");
  }

  /// Fetch UDID
  static String get fetchUDID {
    return _getEnvVariable("X_APPLICATION_UDID");
  }

  /// Fetch GPS Base URL
  static String get fetchGpsBaseUrl {
    return _getEnvVariable("GPS_BASE_URL");
  }

  /// Helper method to fetch environment variables safely
  static String _getEnvVariable(String key) {
    final devValue = dotenv.env[key] ?? "";
    final prodValue = dotenv.env[key] ?? "";

    switch (EnvironmentController.currentEnv) {
      case EnvironmentController.DEV:
        return devValue.isNotEmpty
            ? devValue
            : throw Exception("$key not found in .env for DEV");
      case EnvironmentController.PROD:
        return prodValue.isNotEmpty
            ? prodValue
            : throw Exception("$key not found in .env for PROD");
      default:
        throw Exception("Failed to fetch $key: Unknown environment");
    }
  }
}
