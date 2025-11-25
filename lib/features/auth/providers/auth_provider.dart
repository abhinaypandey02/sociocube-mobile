import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sociocube/core/router/app_router.dart';
import '../../../core/providers/user.dart';
import '../../../core/router/app_routes.dart';
import '../models/auth_state.dart';
import '../services/auth_api.dart';
import '../services/auth_storage.dart';

// Service providers
final authApiProvider = Provider<AuthApi>((ref) => AuthApi());
final authStorageProvider = Provider<AuthStorage>((ref) => AuthStorage());

// Auth notifier
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    return AuthState(accessToken: await getNewAccessToken());
  }

  Future<void> onComplete() async {
    if (!state.hasValue) {
      return;
    }
    final user = await ref.read(userProvider.notifier).fetchUser();
    if (user?.user?.id == null) {
      ref.read(routerProvider).go(AppRoutes.signup);
      return;
    }
    if (user?.user?.isOnboarded == true) {
      ref.read(routerProvider).go(AppRoutes.home);
    } else {
      ref.read(routerProvider).go(AppRoutes.onboarding);
    }
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

      final userId = response.toUserId();
      state = AsyncData(
        AuthState(userId: userId, accessToken: response.accessToken),
      );

      await onComplete();
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

      final userId = response.toUserId();
      await ref.read(userProvider.notifier).fetchUser();
      state = AsyncData(
        AuthState(userId: userId, accessToken: response.accessToken),
      );
      await onComplete();
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
    if (state.value?.accessToken != null &&
        !JwtDecoder.isExpired(state.value!.accessToken!)) {
      return state.value!.accessToken;
    }
    return await getNewAccessToken();
  }

  Future<void> logout() async {
    try {
      final storage = ref.read(authStorageProvider);
      await storage.clearRefreshToken();

      state = AsyncData(AuthState());
      ref.read(routerProvider).go(AppRoutes.login);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

// Provider
final authStateProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
