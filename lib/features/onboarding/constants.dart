import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';
import 'types.dart';
import 'widgets/steps/role.dart';
import 'widgets/steps/socials.dart';
import 'widgets/steps/info.dart';
import 'widgets/steps/niche.dart';
import 'widgets/steps/username.dart';

// Define all onboarding steps in an array
List<OnboardingStepConfig> getOnboardingSteps(Enum$Roles role) {
  return [
    OnboardingStepConfig(builder: RoleStep.new),
    OnboardingStepConfig(builder: SocialsStep.new),
    OnboardingStepConfig(builder: InfoStep.new),
    if (role == Enum$Roles.Creator)
      OnboardingStepConfig(builder: NicheStep.new),
    OnboardingStepConfig(builder: UsernameStep.new),
  ];
}

/// Cached value for total number of onboarding steps
Map<Enum$Roles, int> totalOnboardingSteps = {
  Enum$Roles.Creator: getOnboardingSteps(Enum$Roles.Creator).length,
  Enum$Roles.Brand: getOnboardingSteps(Enum$Roles.Brand).length,
  Enum$Roles.Agency: getOnboardingSteps(Enum$Roles.Agency).length,
};
