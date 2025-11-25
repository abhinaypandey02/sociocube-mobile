import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final int currentStepIndex;
  final int totalSteps;

  const OnboardingPageIndicator({
    super.key,
    required this.currentStepIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${currentStepIndex + 1} of $totalSteps',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalSteps,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: currentStepIndex == index ? 32.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: currentStepIndex == index
                    ? AppColors.primary
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
