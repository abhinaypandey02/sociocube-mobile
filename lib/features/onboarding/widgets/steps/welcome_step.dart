import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../base_step.dart';
import '../role_selector.dart';

enum Role { creator, brand, agency }

// ignore: must_be_immutable
class WelcomeStep extends BaseOnboardingStep {
  WelcomeStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Let's get you onboarded",
         subtitle:
             'With some simple steps you can onboard to become a creator on Sociocube!',
       );

  @override
  Future<void> handleNext() async {
    // TODO: Implement welcome logic
  }

  @override
  Widget buildStepContent(BuildContext context) {
    final selectedRole = useState<Role?>(null);

    useEffect(() {
      super.isNextEnabled = selectedRole.value != null;
    }, [selectedRole.value]);

    return Column(
      spacing: 14,
      children: [
        Row(
          children: [
            Expanded(
              child: RoleSelector(
                isSelected: selectedRole.value == Role.creator,
                onSelect: () => selectedRole.value = Role.creator,
                title: 'Creator',
                subtitle: 'Create and share content with your audience',
              ),
            ),
          ],
        ),
        IntrinsicHeight(
          child: Row(
            spacing: 14,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RoleSelector(
                  isSelected: selectedRole.value == Role.brand,
                  onSelect: () => selectedRole.value = Role.brand,
                  title: 'Brand',
                  subtitle: 'Connect with creators to promote your brand',
                ),
              ),
              Expanded(
                child: RoleSelector(
                  isSelected: selectedRole.value == Role.agency,
                  onSelect: () => selectedRole.value = Role.agency,
                  title: 'Agency',
                  subtitle: 'Manage creators with professional tools',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
