import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/models/auth_state.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final hasInitialized = useState(false);

    // Listen only on first successful auth load
    ref.listen(authStateProvider, (previous, next) {
      if (!hasInitialized.value &&
          previous?.isLoading == true &&
          next.hasValue) {
        hasInitialized.value = true;
        ref.read(authStateProvider.notifier).onComplete();
      }
    });

    return MaterialApp.router(
      title: 'SocioCube Mobile',
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
