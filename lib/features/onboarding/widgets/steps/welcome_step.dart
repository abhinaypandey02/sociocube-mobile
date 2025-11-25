import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../styles.dart';
import '../base_step.dart';

class WelcomeStep extends BaseOnboardingStep {
  const WelcomeStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: 'Welcome to SocioCube!',
         subtitle:
             'Connect with friends, share moments, and build your community in a whole new way.',
         isSkippable: true,
       );

  @override
  Future<void> handleNext() async {
    // TODO: Implement welcome logic
  }

  @override
  Widget buildStepContent(BuildContext context) {
    return Container(
      width: OnboardingSize.iconContainerSize,
      height: OnboardingSize.iconContainerSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.people,
        size: OnboardingSize.iconSize,
        color: AppColors.primary,
      ),
    );
  }
}
