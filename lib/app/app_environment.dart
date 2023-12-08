import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum BuildFlavor {
  development,
  production;

  static BuildFlavor fromString(String value) {
    switch (value) {
      case 'development':
        return BuildFlavor.development;
      case 'production':
        return BuildFlavor.production;
      default:
        exit(1);
    }
  }
}

class AppEnvironment {
  AppEnvironment._();

  static Future<void> load() async {
    const environment = kDebugMode ? 'development' : 'production';

    const envFileName = './env/.env.$environment';

    log('Loading environment: $envFileName');

    final localEnv = await _DotEnvLoader.load('.env.local');

    if (localEnv.isNotEmpty) {
      log('Merging env with local $localEnv');
    }

    await dotenv.load(fileName: envFileName, mergeWith: localEnv);

    log('loaded env ${dotenv.env}');
  }

  static String get apiUrl => dotenv.get('API_URL');

  static String? get debugEmail => dotenv.maybeGet('DEBUG_EMAIL');

  static String? get debugPassword => dotenv.maybeGet('DEBUG_PASSWORD');
}

class _DotEnvLoader {
  static Future<Map<String, String>> load(String filename) async {
    String? envString;

    try {
      envString = await rootBundle.loadString(filename);
    } catch (e) {
      log('', error: e);
    }

    if (envString == null || envString.isEmpty) {
      return {};
    }

    final fileLines = envString.split('\n');
    const dotEnvParser = Parser();

    return dotEnvParser.parse(fileLines);
  }
}
