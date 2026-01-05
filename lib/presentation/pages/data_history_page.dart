import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/sensor_provider.dart';
import '../../models/sensor_reading_model.dart';
import '../widgets/status_badge.dart';

class DataHistoryPage extends StatefulWidget {
  final String sensorId;

  const DataHistoryPage({super.key, required this.sensorId});

  @override
  State<DataHistoryPage> createState() => _DataHistoryPageState();
}

class _DataHistoryPageState extends State<DataHistoryPage> {
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.elevated,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearDateRange() {
    setState(() {
      _selectedDateRange = null;
    });
  }

  List<SensorReadingModel> _filterReadingsByDateRange(
    List<SensorReadingModel> readings,
  ) {
    if (_selectedDateRange == null) return readings;

    return readings.where((reading) {
      final date = reading.timestamp;
      return date.isAfter(
            _selectedDateRange!.start.subtract(const Duration(days: 1)),
          ) &&
          date.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

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
          'Riwayat Data',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          final sensor = provider.getSensorById(widget.sensorId);
          final allReadings = provider.getReadingsForSensor(widget.sensorId);
          final readings = _filterReadingsByDateRange(allReadings);

          if (sensor == null) {
            return const Center(child: Text('Sensor tidak ditemukan'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sensor Name Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                color: AppColors.elevated,
                child: Text(sensor.name, style: AppTypography.section),
              ),

              // Date Range Filter Card
              Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: GestureDetector(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.elevated,
                      borderRadius: BorderRadius.circular(AppSpacing.radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: _selectedDateRange != null
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedDateRange != null
                                ? '${_formatDateShort(_selectedDateRange!.start)} - ${_formatDateShort(_selectedDateRange!.end)}'
                                : 'Rentang Tanggal',
                            style: AppTypography.body.copyWith(
                              color: _selectedDateRange != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (_selectedDateRange != null)
                          GestureDetector(
                            onTap: _clearDateRange,
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Readings List
              Expanded(
                child: readings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedDateRange != null
                                  ? 'Tidak ada data pada rentang tanggal ini'
                                  : 'Belum ada riwayat data',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.pagePadding,
                        ),
                        itemCount: readings.length,
                        itemBuilder: (context, index) {
                          final reading = readings[index];
                          return _buildReadingItem(reading, sensor.unit);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReadingItem(SensorReadingModel reading, String unit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppSpacing.cardDecoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(reading.timestamp),
                  style: AppTypography.caption,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      reading.value.toStringAsFixed(1),
                      style: AppTypography.section.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      ' $unit',
                      style: AppTypography.body.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusBadge(status: reading.status),
        ],
      ),
    );
  }

  String _formatDateShort(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year;
    return '$day $month $year';
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$minute';
  }

  String _getMonthName(int month) {
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
}
