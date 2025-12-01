import 'package:flutter/material.dart';
import 'types.dart';
import 'constants.dart';
import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';

/// Helper function to build onboarding step content based on step number
Widget buildOnboardingStep(
  int stepIndex,
  OnboardingStepUpdater updateStep,
  VoidCallback onNext,
  Enum$Roles role,
) {
  if (stepIndex < 0 || stepIndex >= (totalOnboardingSteps[role] ?? 0)) {
    return const SizedBox.shrink();
  }

  final stepConfig = getOnboardingSteps(role)[stepIndex];

  return stepConfig.builder(
    stepIndex: stepIndex,
    updateStep: updateStep,
    onNext: onNext,
  );
}
