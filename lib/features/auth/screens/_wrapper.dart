import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../core/widgets/button/button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/text.dart';

class AuthHint {
  final String question;
  final String actionText;
  final VoidCallback? onTap;

  const AuthHint({
    required this.question,
    required this.actionText,
    this.onTap,
  });
}

Widget authWrapper({
  required GlobalKey<FormState> formKey,
  String title = '',
  List<Widget> inputs = const [],
  VoidCallback? onPressed,
  String buttonText = '',
  AuthHint? hint,
  required WidgetRef ref,
}) {
  final authState = ref.watch(authStateProvider);
  final isLoading = authState.isLoading;
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 96,
          bottom: 16, // Small padding at bottom for hint
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sans',
                  fontVariations: getVariations(Size.medium, 500),
                  height: 0.5,
                ),
              ),
              Text(
                "sociocube",
                style: TextStyle(
                  fontSize: 48,
                  fontFamily: 'Serif',
                  fontStyle: FontStyle.italic,
                  fontVariations: getVariations(Size.large, 600),
                ),
              ),
              const SizedBox(height: 48),

              ...inputs
                  .map((input) => [input, const SizedBox(height: 12)])
                  .expand((x) => x),
              const SizedBox(height: 16),
              Button(
                loading: isLoading,
                onPressed: onPressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(buttonText),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (hint != null)
                createAuthHint(
                  hint.question,
                  hint.actionText,
                  onTap: hint.onTap,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Helper function to create a hint widget like "Create a new account instead? Get started now!"
Widget createAuthHint(
  String question,
  String actionText, {
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, height: 1.5, fontFamily: 'Sans'),
        children: [
          TextSpan(
            text: "$question ",
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextSpan(
            text: actionText,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
