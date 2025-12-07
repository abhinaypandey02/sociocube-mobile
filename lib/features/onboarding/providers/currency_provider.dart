import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier to manage the currency symbol of the selected country during onboarding
class OnboardingCurrencyNotifier extends Notifier<String> {
  @override
  String build() => '\$';

  /// Update the currency symbol
  void updateCurrency(String currency) {
    state = currency;
  }
}

/// Provider to store the currency symbol of the selected country during onboarding
final onboardingCurrencyProvider =
    NotifierProvider<OnboardingCurrencyNotifier, String>(
      OnboardingCurrencyNotifier.new,
    );
