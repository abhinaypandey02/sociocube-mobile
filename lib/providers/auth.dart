import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Secure storage instance
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

// Access token provider
final accessTokenProvider = StateNotifierProvider<TokenNotifier, String?>((
  ref,
) {
  return TokenNotifier();
});

// Refresh token provider
final refreshTokenProvider =
    StateNotifierProvider<RefreshTokenNotifier, String?>((ref) {
      final secureStorage = ref.watch(secureStorageProvider);
      return RefreshTokenNotifier(secureStorage);
    });

class TokenNotifier extends StateNotifier<String?> {
  TokenNotifier() : super(null);

  void setToken(String token) {
    state = token;
  }

  void clearToken() {
    state = null;
  }
}

class RefreshTokenNotifier extends TokenNotifier {
  final FlutterSecureStorage _secureStorage;
  static const String _key = 'refresh_token';

  RefreshTokenNotifier(this._secureStorage) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _secureStorage.read(key: _key);
    state = token;
  }

  @override
  Future<void> setToken(String token) async {
    await _secureStorage.write(key: _key, value: token);
    super.setToken(token);
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.delete(key: _key);
    super.clearToken();
  }
}
