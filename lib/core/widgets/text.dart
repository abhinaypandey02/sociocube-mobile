import 'dart:ui';
import 'package:flutter/material.dart';

/// Optical size presets for font variations.
enum Size {
  small(12),
  medium(24),
  large(36);

  final double value;
  const Size(this.value);
}

/// Returns font variations for optical size and optional weight.
/// Usage: TextStyle(fontVariations: [...getVariations(Size.medium, 400)])
List<FontVariation> getVariations(Size size, [double? weight]) {
  return [
    FontVariation('opsz', size.value),
    if (weight != null) FontVariation('wght', weight),
  ];
}
