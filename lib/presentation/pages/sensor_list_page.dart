import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/sensor_provider.dart';
import '../widgets/sensor_card.dart';
import 'sensor_detail_page.dart';
import 'add_sensor_page.dart';

class SensorListPage extends StatefulWidget {
  const SensorListPage({super.key});

  @override
  State<SensorListPage> createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
  final TextEditingController _searchController = TextEditingController();
  SensorFilter _selectedFilter = SensorFilter.semua;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Daftar Sensor',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddSensorPage()),
              );
            },
            child: Text(
              'Tambah',
              style: AppTypography.body.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          final filteredSensors = provider.searchAndFilterSensors(
            _searchQuery,
            _selectedFilter,
          );

          return Column(
            children: [
              // Search Bar
              Container(
                color: AppColors.elevated,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: AppTypography.body,
                    decoration: InputDecoration(
                      hintText: 'Cari sensor atau lokasi...',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),

              // Filter Chips
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SensorFilter.values.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getFilterLabel(filter)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: AppColors.elevated,
                          selectedColor: AppColors.primary.withOpacity(0.15),
                          labelStyle: AppTypography.caption.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Sensor List
              Expanded(
                child: filteredSensors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sensors_off,
                              size: 64,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak ada sensor ditemukan',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.pagePadding),
                        itemCount: filteredSensors.length,
                        itemBuilder: (context, index) {
                          final sensor = filteredSensors[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SensorCard.fromModel(
                              sensor,
                              isCompact: true,
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
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getFilterLabel(SensorFilter filter) {
    switch (filter) {
      case SensorFilter.semua:
        return 'Semua';
      case SensorFilter.aktif:
        return 'Aktif';
      case SensorFilter.nonaktif:
        return 'Nonaktif';
      case SensorFilter.peringatan:
        return 'Peringatan';
    }
  }
}
