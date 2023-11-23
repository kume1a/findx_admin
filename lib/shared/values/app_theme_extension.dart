import 'package:flutter/material.dart';

extension ThemeDataX on ThemeData {
  AppThemeExtension? get appThemeExtension => extension<AppThemeExtension>();
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  AppThemeExtension({
    required this.elSecondary,
    required this.elPrimary,
  });

  final Color elSecondary;
  final Color elPrimary;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? elSecondary,
    Color? elPrimary,
  }) {
    return AppThemeExtension(
      elSecondary: elSecondary ?? this.elSecondary,
      elPrimary: elPrimary ?? this.elPrimary,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      elSecondary: Color.lerp(elSecondary, other.elSecondary, t) ?? elSecondary,
      elPrimary: Color.lerp(elPrimary, other.elPrimary, t) ?? elPrimary,
    );
  }
}
