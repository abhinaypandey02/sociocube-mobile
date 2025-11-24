import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/auth_state.dart';
import '../services/auth_api.dart';
import '../services/auth_storage.dart';

// Service providers
final authApiProvider = Provider<AuthApi>((ref) => AuthApi());
final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

// Auth notifier
class AuthNotifier extends AsyncNotifier<AuthState> {
  bool _hasInitialized = false;

  bool get hasInitialized => _hasInitialized;

  @override
  Future<AuthState> build() async {
    final storage = ref.read(authStorageProvider);
    final api = ref.read(authApiProvider);

    final refreshToken = await storage.getRefreshToken();
    _hasInitialized = true;

    if (refreshToken == null) return AuthState();

    final accessToken = await api.refreshAccessToken(refreshToken);
    if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      return AuthState(accessToken: accessToken);
    }

    return AuthState();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(authApiProvider);
      final storage = ref.read(authStorageProvider);

      final response = await api.login(email: email, password: password);

      if (response.refreshToken != null) {
        await storage.saveRefreshToken(response.refreshToken!);
      }

      final user = response.toUser();

      state = AsyncData(
        AuthState(user: user, accessToken: response.accessToken),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signup({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(authApiProvider);
      final storage = ref.read(authStorageProvider);

      final response = await api.signup(email: email, password: password);

      if (response.refreshToken != null) {
        await storage.saveRefreshToken(response.refreshToken!);
      }

      final user = response.toUser();

      state = AsyncData(
        AuthState(user: user, accessToken: response.accessToken),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final storage = ref.read(authStorageProvider);
      await storage.clearRefreshToken();
      state = AsyncData(AuthState());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

// Provider
final authStateProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
