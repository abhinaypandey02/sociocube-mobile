import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../types.dart';
import '../styles.dart';
import 'navigation_buttons.dart';

/// Base class for all onboarding step widgets
/// Handles common configuration and layout structure
/// Merged from BaseOnboardingStep and OnboardingPageLayout
abstract class BaseOnboardingStep extends HookWidget {
  final int stepIndex;
  final OnboardingStepUpdater updateStep;
  final VoidCallback onNext;
  final String title;
  final String subtitle;
  final bool isSkippable;

  const BaseOnboardingStep({
    super.key,
    required this.stepIndex,
    required this.updateStep,
    required this.onNext,
    required this.title,
    required this.subtitle,
    this.isSkippable = false,
  });

  /// Override this method to provide the unique content for each step
  Widget buildStepContent(BuildContext context);

  /// Override this method to add custom logic when next button is pressed
  /// This will be called before the parent's onNext callback
  Future<void> handleNext();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    Future<void> _handleNext() async {
      if (isLoading.value) return;

      isLoading.value = true;
      try {
        await handleNext();
        onNext();
      } finally {
        isLoading.value = false;
      }
    }

    final subtitleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade700;

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
                buildStepContent(context),
                const SizedBox(height: OnboardingSpacing.titleSpacing),

                // Title
                Text(
                  title,
                  style: OnboardingTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: OnboardingSpacing.subtitleSpacing),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: OnboardingTextStyles.subtitleFontSize,
                    color: subtitleColor,
                    height: OnboardingTextStyles.subtitleHeight,
                  ),
                  textAlign: TextAlign.center,
                ),
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
        ),
      ],
    );
  }
}
