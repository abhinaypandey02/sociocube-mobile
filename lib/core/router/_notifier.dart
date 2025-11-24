import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Simple ChangeNotifier that listens to auth state changes
/// GoRouter requires a Listenable, so we can't use NotifierProvider directly
class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(Ref ref) {
    // Listen to auth state and notify GoRouter when it changes
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}

/// Provider for router notifier
final routerNotifierProvider = Provider.autoDispose<AuthRouterNotifier>((ref) {
  return AuthRouterNotifier(ref);
});
