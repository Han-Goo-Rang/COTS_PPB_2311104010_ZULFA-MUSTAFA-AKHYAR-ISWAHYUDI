import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final bool enabled;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const CustomInput({
    super.key,
    required this.label,
    this.placeholder,
    required this.controller,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled ? AppColors.elevated : AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            border: Border.all(
              color: errorText != null ? AppColors.danger : AppColors.border,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            enabled: enabled,
            onChanged: onChanged,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppTypography.body.copyWith(
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              suffixIcon: suffix,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTypography.smallLabel.copyWith(color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}
