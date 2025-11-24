import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_gradients.dart';

/// Main theme configuration
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    final colorScheme = baseScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: 'Sans',
      extensions: const [AppGradients.defaults],
    );
  }
}
