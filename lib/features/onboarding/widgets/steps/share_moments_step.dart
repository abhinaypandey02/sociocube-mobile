import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../styles.dart';
import '../base_step.dart';

class ShareMomentsStep extends BaseOnboardingStep {
  const ShareMomentsStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: 'Share Your Moments',
         subtitle:
             'Capture and share your best moments with photos, videos, and stories that matter to you.',
         isSkippable: false,
       );

  @override
  Future<void> handleNext() async {
    // TODO: Implement share moments logic
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
        Icons.photo_camera,
        size: OnboardingSize.iconSize,
        color: AppColors.primary,
      ),
    );
  }
}
