import 'package:go_router/go_router.dart';
import '../screens/home.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        // Add more routes as needed
      ],
    );
  }
} 