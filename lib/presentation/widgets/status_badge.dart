import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../models/sensor_model.dart';

class StatusBadge extends StatelessWidget {
  final SensorStatus status;
  final bool isCompact;

  const StatusBadge({super.key, required this.status, this.isCompact = false});

  Color get _backgroundColor {
    switch (status) {
      case SensorStatus.normal:
        return AppColors.success.withOpacity(0.15);
      case SensorStatus.peringatan:
        return AppColors.warning.withOpacity(0.15);
      case SensorStatus.tinggi:
        return AppColors.danger.withOpacity(0.15);
      case SensorStatus.rendah:
        return AppColors.secondary.withOpacity(0.15);
      case SensorStatus.nonaktif:
        return AppColors.textSecondary.withOpacity(0.15);
    }
  }

  Color get _textColor {
    switch (status) {
      case SensorStatus.normal:
        return AppColors.success;
      case SensorStatus.peringatan:
        return AppColors.warning;
      case SensorStatus.tinggi:
        return AppColors.danger;
      case SensorStatus.rendah:
        return AppColors.secondary;
      case SensorStatus.nonaktif:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(isCompact ? 4 : 6),
      ),
      child: Text(
        status.displayName,
        style: (isCompact ? AppTypography.smallLabel : AppTypography.caption)
            .copyWith(color: _textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
