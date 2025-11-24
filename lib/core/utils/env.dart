import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvKey {
  turnstileSiteKey,
  backendBaseUrl,
}

extension EnvKeyExtension on EnvKey {
  String get value {
    switch (this) {
      case EnvKey.turnstileSiteKey:
        return 'TURNSTILE_SITE_KEY';
      case EnvKey.backendBaseUrl:
        return 'BACKEND_BASE_URL';
    }
  }
}

String getEnvVar(EnvKey key) {
  return dotenv.env[key.value] ?? '';
}