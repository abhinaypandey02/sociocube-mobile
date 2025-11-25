import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../types.dart';
import '../styles.dart';
import '../constants.dart';

class OnboardingNavigationButtons extends StatelessWidget {
  final int currentStepIndex;
  final OnboardingStepUpdater updateStep;
  final Future<void> Function() onNext;
  final bool isLoading;

  const OnboardingNavigationButtons({
    super.key,
    required this.currentStepIndex,
    required this.updateStep,
    required this.onNext,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalSteps = getTotalOnboardingSteps();
    final isLastStep = currentStepIndex >= totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.all(OnboardingSpacing.buttonPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (currentStepIndex > 0)
            Semantics(
              label: 'Go to previous onboarding step',
              button: true,
              child: OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () => updateStep((prev) => prev - 1),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OnboardingSpacing.buttonHorizontal,
                    vertical: OnboardingSpacing.buttonVertical,
                  ),
                ),
                child: const Text('Back'),
              ),
            )
          else
            const Spacer(),

          // Next/Get Started button
          Semantics(
            label: isLastStep
                ? 'Complete onboarding and get started'
                : 'Go to next onboarding step',
            button: true,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await onNext();
                      if (!isLastStep) {
                        updateStep((prev) => prev + 1);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: OnboardingSpacing.buttonHorizontal,
                  vertical: OnboardingSpacing.buttonVertical,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isLastStep ? 'Get Started' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
