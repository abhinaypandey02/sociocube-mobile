import 'package:flutter/material.dart';

/// App gradient definitions using ThemeExtension
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.primary,
    required this.accent,
    required this.dark,
    required this.danger,
  });

  final Gradient primary;
  final Gradient accent;
  final Gradient dark;
  final Gradient danger;

  /// Default gradient values
  static const AppGradients defaults = AppGradients(
    primary: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF65B071), Color(0xFF508959)],
    ),
    accent: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF7B70FF), Color(0xFF5D53CB)],
    ),
    dark: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF404040), Color(0xFF141414)],
    ),
    danger: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFED343D), Color(0xFFC12C33)],
    ),
  );

  @override
  AppGradients copyWith({
    Gradient? primary,
    Gradient? accent,
    Gradient? dark,
    Gradient? danger,
  }) {
    return AppGradients(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      dark: dark ?? this.dark,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) {
      return this;
    }

    return AppGradients(
      primary: Gradient.lerp(primary, other.primary, t) ?? primary,
      accent: Gradient.lerp(accent, other.accent, t) ?? accent,
      dark: Gradient.lerp(dark, other.dark, t) ?? dark,
      danger: Gradient.lerp(danger, other.danger, t) ?? danger,
    );
  }
}
