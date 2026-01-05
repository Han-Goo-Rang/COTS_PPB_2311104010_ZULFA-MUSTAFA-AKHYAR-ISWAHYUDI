import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/sensor_provider.dart';
import '../../models/sensor_model.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_toggle.dart';
import 'data_history_page.dart';

class SensorDetailPage extends StatelessWidget {
  final String sensorId;

  const SensorDetailPage({super.key, required this.sensorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.elevated,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Sensor',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Navigate to edit page
            },
            child: Text(
              'Edit',
              style: AppTypography.body.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          final sensor = provider.getSensorById(sensorId);

          if (sensor == null) {
            return const Center(child: Text('Sensor tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sensor Info Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
                  decoration: AppSpacing.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nama Sensor', sensor.name),
                      const SizedBox(height: 16),
                      _buildInfoRow('Lokasi', sensor.location),
                      const SizedBox(height: 16),
                      _buildInfoRow('Tipe Sensor', sensor.type.displayName),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status', style: AppTypography.caption),
                          StatusBadge(
                            status:
                                sensor.currentStatus ?? SensorStatus.nonaktif,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Current Value Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
                  decoration: AppSpacing.cardDecoration,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            sensor.currentValue?.toStringAsFixed(1) ?? '-',
                            style: AppTypography.largeValue,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              ' ${sensor.unit}',
                              style: AppTypography.section.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pengaturan Section
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
                  decoration: AppSpacing.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengaturan', style: AppTypography.section),
                      const SizedBox(height: 16),
                      CustomToggle(
                        label: 'Sensor Aktif',
                        value: sensor.isActive,
                        onChanged: (value) {
                          provider.updateSensorStatus(sensorId, value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Lihat Riwayat Data Button
                CustomButton(
                  text: 'Lihat Riwayat Data',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DataHistoryPage(sensorId: sensorId),
                      ),
                    );
                  },
                  isFullWidth: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption),
        Text(
          value,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
