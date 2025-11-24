import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_gradients.dart';

/// Button visual variants
enum ButtonVariant { primary, accent, dark, danger }

/// Style configuration for a button variant
class ButtonVariantStyle {
  final Gradient gradient;
  final Color textColor;

  const ButtonVariantStyle({required this.gradient, required this.textColor});
}

/// Gets the style configuration for a given button variant
ButtonVariantStyle getVariantStyle(
  ButtonVariant variant,
  AppGradients themeGradients,
) {
  switch (variant) {
    case ButtonVariant.primary:
      return ButtonVariantStyle(
        gradient: themeGradients.primary,
        textColor: AppColors.primary,
      );
    case ButtonVariant.accent:
      return ButtonVariantStyle(
        gradient: themeGradients.accent,
        textColor: AppColors.accent,
      );
    case ButtonVariant.dark:
      return ButtonVariantStyle(
        gradient: themeGradients.dark,
        textColor: AppColors.dark,
      );
    case ButtonVariant.danger:
      return ButtonVariantStyle(
        gradient: themeGradients.danger,
        textColor: AppColors.danger,
      );
  }
}
