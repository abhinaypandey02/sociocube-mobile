import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/widgets/input/input.dart';
import '../providers/auth_provider.dart';
import '_wrapper.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for form controllers
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Login handler
    Future<void> handleSignup() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      try {
        ref
            .read(authStateProvider.notifier)
            .signup(
              email: emailController.text.trim(),
              password: passwordController.text,
            );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return authWrapper(
      ref: ref,
      formKey: formKey,
      title: "Welcome to",
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
          hint: 'Create your password',
          label: "Password",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
      ],
      onPressed: handleSignup,
      buttonText: "Get started",
      hint: AuthHint(
        question: "Already have an account?",
        actionText: "Sign in now!",
        onTap: () => context.go('/login'),
      ),
    );
  }
}
