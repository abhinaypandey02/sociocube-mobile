import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login.dart';
import '../../features/auth/screens/signup.dart';
import '../../features/home/screens/home.dart';
import '../../features/onboarding/screens/onboarding.dart';
import '../widgets/splash_screen.dart';
import 'app_routes.dart';

/// Route configurations with screen widgets
/// Separate from route paths to avoid heavy imports when just using paths
class RouteConfig {
  const RouteConfig._();

  static final List<RouteBase> routes = [
    // Splash route
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Login route
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // Signup route
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),

    // Home route
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),

    // Onboarding route
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
  ];
}
