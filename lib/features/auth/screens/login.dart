import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/input/input.dart';
import '../providers/auth_provider.dart';
import '_wrapper.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for form controllers
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Login handler
    Future<void> handleLogin() async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      try {
        ref
            .read(authStateProvider.notifier)
            .login(
              email: emailController.text.trim(),
              password: passwordController.text,
            );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return authWrapper(
      ref: ref,
      formKey: formKey,
      title: "Get back to",
      inputs: [
        Input(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hint: 'Enter your email',
          label: "Email address",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        Input(
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          hint: 'Enter your password',
          label: "Password",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
      onPressed: handleLogin,
      buttonText: "Log in",
      hint: AuthHint(
        question: "New to Sociocube?",
        actionText: "Get started now!",
        onTap: () => context.go('/signup'),
      ),
    );
  }
}
