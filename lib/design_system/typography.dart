import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  AppTypography._();

  // Title - 22 SemiBold
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Section - 18 SemiBold
  static const TextStyle section = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body - 14 Regular
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Caption - 13 Regular
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Button - 14 SemiBold
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.elevated,
  );

  // Large Value Display - for sensor readings
  static const TextStyle largeValue = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );

  // Small Label
  static const TextStyle smallLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
