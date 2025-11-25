import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'app_routes.dart';
import '_route_list.dart';

// Router provider
// Uses refreshListenable for efficient auth state monitoring
final routerProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false, // Set to true for debugging
    routes: RouteConfig.routes,
    // 404 handler - auto-redirect based on auth state
    errorBuilder: (context, state) {
      final currentAuthState = ref.read(authStateProvider);
      final isAuthenticated = currentAuthState.value?.accessToken != null;
      final destination = isAuthenticated ? AppRoutes.home : AppRoutes.login;

      // Auto-redirect after a brief moment
      Future.microtask(() => context.go(destination));

      // Show brief loading while redirecting
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    },
  );
});
