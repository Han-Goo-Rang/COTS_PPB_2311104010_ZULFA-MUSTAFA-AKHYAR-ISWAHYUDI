import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/sensor_provider.dart';
import '../../models/sensor_model.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_toggle.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({super.key});

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _unitController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _notesController = TextEditingController();

  SensorType? _selectedType;
  bool _isActive = true;

  String? _nameError;
  String? _locationError;
  String? _typeError;
  String? _minMaxError;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _unitController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _nameError = null;
      _locationError = null;
      _typeError = null;
      _minMaxError = null;

      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Field ini wajib diisi';
        isValid = false;
      }

      if (_locationController.text.trim().isEmpty) {
        _locationError = 'Field ini wajib diisi';
        isValid = false;
      }

      if (_selectedType == null) {
        _typeError = 'Pilih tipe sensor';
        isValid = false;
      }

      final minText = _minController.text.trim();
      final maxText = _maxController.text.trim();

      if (minText.isNotEmpty && maxText.isNotEmpty) {
        final min = double.tryParse(minText);
        final max = double.tryParse(maxText);

        if (min != null && max != null && min > max) {
          _minMaxError = 'Nilai min harus lebih kecil dari max';
          isValid = false;
        }
      }
    });

    return isValid;
  }

  void _saveSensor() {
    if (!_validateForm()) return;

    final provider = context.read<SensorProvider>();

    final unit = _unitController.text.trim().isNotEmpty
        ? _unitController.text.trim()
        : _selectedType?.defaultUnit ?? '';

    final minNormal = double.tryParse(_minController.text.trim()) ?? 0.0;
    final maxNormal = double.tryParse(_maxController.text.trim()) ?? 100.0;

    final newSensor = SensorModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      type: _selectedType!,
      unit: unit,
      minNormal: minNormal,
      maxNormal: maxNormal,
      isActive: _isActive,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      currentValue: _generateRandomValue(minNormal, maxNormal),
      currentStatus: _isActive ? SensorStatus.normal : SensorStatus.nonaktif,
      lastUpdated: DateTime.now(),
    );

    provider.addSensor(newSensor);
    Navigator.pop(context);
  }

  double _generateRandomValue(double min, double max) {
    final random = DateTime.now().millisecond % 100 / 100;
    return min + (max - min) * random;
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
          'Tambah Sensor',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Sensor
                    CustomInput(
                      label: 'Nama Sensor',
                      placeholder: 'Masukkan nama sensor',
                      controller: _nameController,
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 16),

                    // Lokasi
                    CustomInput(
                      label: 'Lokasi',
                      placeholder: 'Masukkan lokasi',
                      controller: _locationController,
                      errorText: _locationError,
                    ),
                    const SizedBox(height: 16),

                    // Tipe Sensor Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipe Sensor',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.elevated,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSmall,
                            ),
                            border: Border.all(
                              color: _typeError != null
                                  ? AppColors.danger
                                  : AppColors.border,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<SensorType>(
                              value: _selectedType,
                              isExpanded: true,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Pilih tipe sensor',
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.textSecondary.withOpacity(
                                      0.6,
                                    ),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              items: SensorType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.displayName,
                                    style: AppTypography.body,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value;
                                  _typeError = null;
                                  if (value != null &&
                                      _unitController.text.isEmpty) {
                                    _unitController.text = value.defaultUnit;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        if (_typeError != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _typeError!,
                            style: AppTypography.smallLabel.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Satuan
                    CustomInput(
                      label: 'Satuan',
                      placeholder: 'Otomatis (misal: °C)',
                      controller: _unitController,
                    ),
                    const SizedBox(height: 16),

                    // Batas Normal (min - max)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Batas Normal (min - max)',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.elevated,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSmall,
                                  ),
                                  border: Border.all(
                                    color: _minMaxError != null
                                        ? AppColors.danger
                                        : AppColors.border,
                                  ),
                                ),
                                child: TextField(
                                  controller: _minController,
                                  keyboardType: TextInputType.number,
                                  style: AppTypography.body,
                                  decoration: InputDecoration(
                                    hintText: 'Min',
                                    hintStyle: AppTypography.body.copyWith(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.6),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.elevated,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusSmall,
                                  ),
                                  border: Border.all(
                                    color: _minMaxError != null
                                        ? AppColors.danger
                                        : AppColors.border,
                                  ),
                                ),
                                child: TextField(
                                  controller: _maxController,
                                  keyboardType: TextInputType.number,
                                  style: AppTypography.body,
                                  decoration: InputDecoration(
                                    hintText: 'Max',
                                    hintStyle: AppTypography.body.copyWith(
                                      color: AppColors.textSecondary
                                          .withOpacity(0.6),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_minMaxError != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _minMaxError!,
                            style: AppTypography.smallLabel.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Aktifkan Sensor Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.elevated,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: CustomToggle(
                        label: 'Aktifkan Sensor',
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Catatan
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.elevated,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSmall,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            controller: _notesController,
                            maxLines: 3,
                            style: AppTypography.body,
                            decoration: InputDecoration(
                              hintText: 'Catatan tambahan (opsional)',
                              hintStyle: AppTypography.body.copyWith(
                                color: AppColors.textSecondary.withOpacity(0.6),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons
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
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Batal',
                      variant: ButtonVariant.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(text: 'Simpan', onPressed: _saveSensor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
