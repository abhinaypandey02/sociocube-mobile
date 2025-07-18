import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';

class AuthUtils {
  // Login function - call this when user logs in
  static Future<void> login(WidgetRef ref, {
    required String accessToken,
    required String refreshToken,
  }) async {
    ref.read(accessTokenProvider.notifier).setToken(accessToken);
    await ref.read(refreshTokenProvider.notifier).setToken(refreshToken);
  }

  // Logout function - call this when user logs out
  static Future<void> logout(WidgetRef ref) async {
    ref.read(accessTokenProvider.notifier).clearToken();
    await ref.read(refreshTokenProvider.notifier).clearToken();
  }

  // Check if user is authenticated
  static bool isAuthenticated(WidgetRef ref) {
    final accessToken = ref.read(accessTokenProvider);
    return accessToken != null && accessToken.isNotEmpty;
  }

  // Get current access token
  static String? getAccessToken(WidgetRef ref) {
    return ref.read(accessTokenProvider);
  }

  // Get current refresh token
  static String? getRefreshToken(WidgetRef ref) {
    return ref.read(refreshTokenProvider);
  }
} 