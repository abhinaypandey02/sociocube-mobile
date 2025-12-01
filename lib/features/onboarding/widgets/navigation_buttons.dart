import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../types.dart';
import '../styles.dart';
import '../constants.dart';
import '../../../core/widgets/button/button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/providers/user.dart';
import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';

class OnboardingNavigationButtons extends HookConsumerWidget {
  final int currentStepIndex;
  final OnboardingStepUpdater updateStep;
  final Future<void> Function() onNext;
  final bool isLoading;
  final bool isDisabled;
  final GlobalKey<FormState> formKey;

  const OnboardingNavigationButtons({
    super.key,
    required this.currentStepIndex,
    required this.updateStep,
    required this.onNext,
    this.isLoading = false,
    this.isDisabled = false,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final role = user.value?.user?.role;
    final totalSteps = totalOnboardingSteps[role ?? Enum$Roles.Creator] ?? 0;
    final isLastStep = currentStepIndex >= totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.all(OnboardingSpacing.buttonPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (currentStepIndex > 0)
            Semantics(
              label: 'Go to previous onboarding step',
              button: true,
              child: Button(
                onPressed: isLoading
                    ? null
                    : () => updateStep((prev) => prev - 1),
                invert: true,
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Back'),
                  ],
                ),
              ),
            )
          else
            const Spacer(),

          // Next/Get Started button
          Semantics(
            label: isLastStep
                ? 'Complete onboarding and get started'
                : 'Go to next onboarding step',
            button: true,
            child: Button(
              disabled: isDisabled,
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      await onNext();
                      if (!isLastStep) {
                        updateStep((prev) => prev + 1);
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      children: [
                        Text(isLastStep ? 'Get Started' : 'Next'),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
