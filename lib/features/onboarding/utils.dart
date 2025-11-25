import 'package:flutter/material.dart';
import 'types.dart';
import 'constants.dart';

/// Helper function to build onboarding step content based on step number
Widget buildOnboardingStep(
  int stepIndex,
  OnboardingStepUpdater updateStep,
  VoidCallback onNext,
) {
  if (stepIndex < 0 || stepIndex >= getTotalOnboardingSteps()) {
    return const SizedBox.shrink();
  }

  final stepConfig = onboardingSteps[stepIndex];

  return stepConfig.builder(
    stepIndex: stepIndex,
    updateStep: updateStep,
    onNext: onNext,
  );
}
