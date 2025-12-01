import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/widgets/text.dart';
import '../types.dart';
import '../styles.dart';
import 'navigation_buttons.dart';

/// Base class for all onboarding step widgets
/// Handles common configuration and layout structure
/// Merged from BaseOnboardingStep and OnboardingPageLayout
// ignore: must_be_immutable
abstract class BaseOnboardingStep extends HookConsumerWidget {
  final int stepIndex;
  final OnboardingStepUpdater updateStep;
  final VoidCallback onNext;
  final String title;
  final String subtitle;
  final bool isSkippable;
  bool isNextEnabled;

  BaseOnboardingStep({
    super.key,
    required this.stepIndex,
    required this.updateStep,
    required this.onNext,
    required this.title,
    required this.subtitle,
    this.isSkippable = false,
    this.isNextEnabled = true,
  });

  /// Override this method to provide the unique content for each step
  Widget buildStepContent(BuildContext context, WidgetRef ref);

  /// Override this method to add custom logic when next button is pressed
  /// This will be called before the parent's onNext callback
  Future<void> handleNext(WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    Future<void> _handleNext() async {
      if (isLoading.value) return;

      isLoading.value = true;
      try {
        await handleNext(ref);
        onNext();
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      children: [
        // Skip button
        if (isSkippable && !isLoading.value)
          Padding(
            padding: const EdgeInsets.all(OnboardingSpacing.skipButtonPadding),
            child: Align(
              alignment: Alignment.topRight,
              child: Semantics(
                label: 'Skip this onboarding step',
                button: true,
                child: TextButton(
                  onPressed: () => updateStep((prev) => prev + 1),
                  child: const Text('Skip'),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: OnboardingSpacing.skipButtonHeight),

        // Step content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(OnboardingSpacing.contentPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Step content (icon, image, etc.)

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 36,
                    fontVariations: getVariations(Size.medium, 600),
                    fontFamily: 'Serif',
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),
                buildStepContent(context, ref),
              ],
            ),
          ),
        ),

        // Navigation buttons
        OnboardingNavigationButtons(
          currentStepIndex: stepIndex,
          updateStep: updateStep,
          onNext: _handleNext,
          isLoading: isLoading.value,
          isDisabled: !isNextEnabled,
        ),
      ],
    );
  }
}
