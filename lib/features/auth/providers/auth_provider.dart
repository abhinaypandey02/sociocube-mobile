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
    final accessToken = await getNewAccessToken();
    _hasInitialized = true;
    return AuthState(accessToken: accessToken);
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

  Future<String?> getNewAccessToken() async {
    try {
      final api = ref.read(authApiProvider);
      final storage = ref.read(authStorageProvider);
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) {
        return null;
      }
      final accessToken = await api.refreshAccessToken(refreshToken);
      if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
        return accessToken;
      }
      return null;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    if(state.value?.accessToken != null && !JwtDecoder.isExpired(state.value!.accessToken!)) {
      return state.value!.accessToken;
    }
    return await getNewAccessToken();
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
