import 'package:flutter/material.dart';
import 'colors.dart';

class AppSpacing {
  AppSpacing._();

  // Grid System
  static const double grid = 8.0;

  // Border Radius
  static const double radius = 14.0;
  static const double radiusSmall = 8.0;
  static const double radiusLarge = 20.0;

  // Padding
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;
  static const double pagePadding = 16.0;

  // Button
  static const double buttonHeight = 48.0;

  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Card Shadow
  static BoxShadow get cardShadow => BoxShadow(
    color: AppColors.textPrimary.withOpacity(0.08),
    offset: const Offset(0, 6),
    blurRadius: 16,
  );

  // Floating Shadow
  static BoxShadow get floatingShadow => BoxShadow(
    color: AppColors.textPrimary.withOpacity(0.12),
    offset: const Offset(0, 10),
    blurRadius: 24,
  );

  // Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.elevated,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [cardShadow],
  );

  // Elevated Card Decoration
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: AppColors.elevated,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [floatingShadow],
  );
}
