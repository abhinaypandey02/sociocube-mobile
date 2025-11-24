import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'app_routes.dart';
import '_route_list.dart';
import '_notifier.dart';

// Router provider
// Uses refreshListenable for efficient auth state monitoring
final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false, // Set to true for debugging
    refreshListenable: routerNotifier, // Re-evaluate redirects on auth changes
    redirect: (context, state) {
      // Re-read auth state on each redirect evaluation
      final currentAuthState = ref.read(authStateProvider);
      final authNotifier = ref.read(authStateProvider.notifier);

      // Show splash screen only during initial loading (not during login/signup)
      if (currentAuthState.isLoading && !authNotifier.hasInitialized) {
        return AppRoutes.splash;
      }

      final isAuthenticated = currentAuthState.value?.accessToken != null;
      final currentLocation = state.matchedLocation;

      // If on splash screen, redirect based on auth state
      if (currentLocation == AppRoutes.splash) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }

      // If not authenticated and not on login/signup pages, redirect to login
      if (!isAuthenticated &&
          currentLocation != AppRoutes.login &&
          currentLocation != AppRoutes.signup) {
        return AppRoutes.login;
      }

      // If authenticated and on auth pages, redirect to home
      if (isAuthenticated &&
          (currentLocation == AppRoutes.login ||
              currentLocation == AppRoutes.signup)) {
        return AppRoutes.home;
      }

      // No redirect needed
      return null;
    },
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
