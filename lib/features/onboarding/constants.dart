import 'types.dart';
import 'widgets/steps/welcome_step.dart';
import 'widgets/steps/share_moments_step.dart';

// Define all onboarding steps in an array
const List<OnboardingStepConfig> onboardingSteps = [
  OnboardingStepConfig(builder: WelcomeStep.new),
  OnboardingStepConfig(builder: ShareMomentsStep.new),
];

/// Cached value for total number of onboarding steps
int? _cachedTotalSteps;

/// Get total number of onboarding steps (cached)
int getTotalOnboardingSteps() {
  _cachedTotalSteps ??= onboardingSteps.length;
  return _cachedTotalSteps!;
}
