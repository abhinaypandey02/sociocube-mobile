import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to store the currency symbol of the selected country during onboarding
final onboardingCurrencyProvider = StateProvider<String>((ref) => '\$');
