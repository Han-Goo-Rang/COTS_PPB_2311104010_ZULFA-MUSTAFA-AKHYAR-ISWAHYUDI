import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/sensor_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/sensor_card.dart';
import '../widgets/custom_button.dart';
import 'sensor_list_page.dart';
import 'add_sensor_page.dart';
import 'sensor_detail_page.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.elevated,
        elevation: 0,
        title: Text(
          'Monitoring Sensor',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SensorListPage()),
              );
            },
            child: Text(
              'Daftar Sensor',
              style: AppTypography.body.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards
                      Row(
                        children: [
                          SummaryCard(
                            icon: Icons.sensors,
                            label: 'Total Sensor',
                            count: provider.totalSensorCount,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          SummaryCard(
                            icon: Icons.check_circle_outline,
                            label: 'Sensor Aktif',
                            count: provider.activeSensorCount,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                          SummaryCard(
                            icon: Icons.warning_amber_outlined,
                            label: 'Peringatan',
                            count: provider.warningCount,
                            color: AppColors.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Data Terbaru Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Data Terbaru', style: AppTypography.section),
                          Text(
                            _getCurrentTimestamp(),
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Sensor Cards List
                      ...provider.sensors.map(
                        (sensor) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SensorCard.fromModel(
                            sensor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SensorDetailPage(sensorId: sensor.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Container(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                decoration: BoxDecoration(
                  color: AppColors.elevated,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: CustomButton(
                    text: 'Tambah Sensor',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddSensorPage(),
                        ),
                      );
                    },
                    isFullWidth: true,
                    icon: Icons.add,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getCurrentTimestamp() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
