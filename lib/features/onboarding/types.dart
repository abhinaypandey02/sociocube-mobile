import 'package:flutter/material.dart';

/// Type definitions for onboarding callbacks
typedef OnboardingStepUpdater = void Function(int Function(int));
typedef OnboardingStepBuilder =
    Widget Function({
      required int stepIndex,
      required OnboardingStepUpdater updateStep,
      required VoidCallback onNext,
    });

/// Configuration for an onboarding step
class OnboardingStepConfig {
  final OnboardingStepBuilder builder;

  const OnboardingStepConfig({required this.builder});
}
