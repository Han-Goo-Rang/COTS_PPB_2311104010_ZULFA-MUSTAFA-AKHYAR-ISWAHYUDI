import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../models/sensor_model.dart';
import 'status_badge.dart';

class SensorCard extends StatelessWidget {
  final String name;
  final String location;
  final String value;
  final String unit;
  final SensorStatus status;
  final String timestamp;
  final VoidCallback? onTap;
  final bool isCompact;

  const SensorCard({
    super.key,
    required this.name,
    required this.location,
    required this.value,
    required this.unit,
    required this.status,
    required this.timestamp,
    this.onTap,
    this.isCompact = false,
  });

  factory SensorCard.fromModel(
    SensorModel sensor, {
    VoidCallback? onTap,
    bool isCompact = false,
  }) {
    return SensorCard(
      name: sensor.name,
      location: sensor.location,
      value: sensor.currentValue?.toStringAsFixed(1) ?? '-',
      unit: sensor.unit,
      status: sensor.currentStatus ?? SensorStatus.nonaktif,
      timestamp: _formatTimestamp(sensor.lastUpdated),
      onTap: onTap,
      isCompact: isCompact,
    );
  }

  static String _formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '-';

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppSpacing.cardDecoration,
        child: isCompact ? _buildCompactLayout() : _buildFullLayout(),
      ),
    );
  }

  Widget _buildFullLayout() {
    final hasValue = value != '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(location, style: AppTypography.caption),
                ],
              ),
            ),
            StatusBadge(status: status),
          ],
        ),
        if (hasValue) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.largeValue.copyWith(fontSize: 32),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  unit,
                  style: AppTypography.body.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Text(
              'Menunggu data...',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(timestamp, style: AppTypography.smallLabel),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(location, style: AppTypography.caption),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StatusBadge(status: status, isCompact: true),
            const SizedBox(height: 8),
            Text(timestamp, style: AppTypography.smallLabel),
          ],
        ),
      ],
    );
  }
}
