import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/page_indicator.dart';
import '../constants.dart';
import '../utils.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Counter to track current onboarding step index
    final currentStepIndex = useState(0);
    final totalSteps = getTotalOnboardingSteps();

    // Function to update current step using a callback
    void updateStep(int Function(int) updater) {
      final newStepIndex = updater(currentStepIndex.value);
      if (newStepIndex >= 0 && newStepIndex < totalSteps) {
        currentStepIndex.value = newStepIndex;
      }
    }

    // Function to handle next button press
    void handleNext() {
      // If on the last step, complete onboarding
      if (currentStepIndex.value >= totalSteps - 1) {
        // Mark onboarding as complete and navigate to home
        context.go('/home');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Onboarding content based on current step
            Expanded(
              child: buildOnboardingStep(
                currentStepIndex.value,
                updateStep,
                handleNext,
              ),
            ),

            // Page indicators
            OnboardingPageIndicator(
              currentStepIndex: currentStepIndex.value,
              totalSteps: totalSteps,
            ),
          ],
        ),
      ),
    );
  }
}
