import 'types.dart';
import 'widgets/steps/role.dart';
import 'widgets/steps/socials.dart';
import 'widgets/steps/info.dart';

// Define all onboarding steps in an array
const List<OnboardingStepConfig> onboardingSteps = [
  OnboardingStepConfig(builder: RoleStep.new),
  OnboardingStepConfig(builder: SocialsStep.new),
  OnboardingStepConfig(builder: InfoStep.new),
];

/// Cached value for total number of onboarding steps
int? _cachedTotalSteps;

/// Get total number of onboarding steps (cached)
int getTotalOnboardingSteps() {
  _cachedTotalSteps ??= onboardingSteps.length;
  return _cachedTotalSteps!;
}
