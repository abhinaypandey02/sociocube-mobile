import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'types.dart';
import 'constants.dart';
import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';

/// Fetches the user's country code based on their IP address
/// Returns null if the request fails or country code is not available
Future<(String?, String?)> fetchUserCountryCode() async {
  try {
    final response = await http.get(Uri.parse('https://ipinfo.io/json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['country'] as String?, data['city'] as String?);
    }
  } catch (e) {
    debugPrint('Error fetching IP info: $e');
  }
  return (null, null);
}

/// Helper function to build onboarding step content based on step number
Widget buildOnboardingStep(
  int stepIndex,
  OnboardingStepUpdater updateStep,
  VoidCallback onNext,
  Enum$Roles role,
) {
  if (stepIndex < 0 || stepIndex >= (totalOnboardingSteps[role] ?? 0)) {
    return const SizedBox.shrink();
  }

  final stepConfig = getOnboardingSteps(role)[stepIndex];

  return stepConfig.builder(
    stepIndex: stepIndex,
    updateStep: updateStep,
    onNext: onNext,
  );
}
