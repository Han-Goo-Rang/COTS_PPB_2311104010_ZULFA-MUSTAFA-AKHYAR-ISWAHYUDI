import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cots_ppb_2311104010_zulfamai/design_system/colors.dart';
import 'package:cots_ppb_2311104010_zulfamai/design_system/typography.dart';
import 'package:cots_ppb_2311104010_zulfamai/design_system/spacing.dart';

void main() {
  group('AppColors - Design System Colors', () {
    test('primary color should be #2563EB', () {
      expect(AppColors.primary, const Color(0xFF2563EB));
    });

    test('secondary color should be #06B6D4', () {
      expect(AppColors.secondary, const Color(0xFF06B6D4));
    });

    test('success color should be #22C55E', () {
      expect(AppColors.success, const Color(0xFF22C55E));
    });

    test('warning color should be #F59E0B', () {
      expect(AppColors.warning, const Color(0xFFF59E0B));
    });

    test('danger color should be #EF4444', () {
      expect(AppColors.danger, const Color(0xFFEF4444));
    });

    test('background color should be #F5F7FB', () {
      expect(AppColors.background, const Color(0xFFF5F7FB));
    });

    test('elevated color should be #FFFFFF', () {
      expect(AppColors.elevated, const Color(0xFFFFFFFF));
    });

    test('textPrimary color should be #0F172A', () {
      expect(AppColors.textPrimary, const Color(0xFF0F172A));
    });

    test('textSecondary color should be #475569', () {
      expect(AppColors.textSecondary, const Color(0xFF475569));
    });
  });

  group('AppTypography - Design System Typography', () {
    test('title should be 22 SemiBold', () {
      expect(AppTypography.title.fontSize, 22);
      expect(AppTypography.title.fontWeight, FontWeight.w600);
    });

    test('section should be 18 SemiBold', () {
      expect(AppTypography.section.fontSize, 18);
      expect(AppTypography.section.fontWeight, FontWeight.w600);
    });

    test('body should be 14 Regular', () {
      expect(AppTypography.body.fontSize, 14);
      expect(AppTypography.body.fontWeight, FontWeight.w400);
    });

    test('caption should be 13 Regular', () {
      expect(AppTypography.caption.fontSize, 13);
      expect(AppTypography.caption.fontWeight, FontWeight.w400);
    });

    test('button should be 14 SemiBold', () {
      expect(AppTypography.button.fontSize, 14);
      expect(AppTypography.button.fontWeight, FontWeight.w600);
    });
  });

  group('AppSpacing - Design System Spacing', () {
    test('grid should be 8pt', () {
      expect(AppSpacing.grid, 8.0);
    });

    test('radius should be 14', () {
      expect(AppSpacing.radius, 14.0);
    });

    test('cardPadding should be 16', () {
      expect(AppSpacing.cardPadding, 16.0);
    });

    test('cardPaddingLarge should be 20', () {
      expect(AppSpacing.cardPaddingLarge, 20.0);
    });
  });
}
