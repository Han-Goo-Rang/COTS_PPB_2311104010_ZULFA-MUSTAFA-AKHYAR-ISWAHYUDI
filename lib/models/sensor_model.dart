enum SensorType { suhu, kelembapan, ph, cahaya, tekanan }

enum SensorStatus { normal, peringatan, tinggi, rendah, nonaktif }

extension SensorTypeExtension on SensorType {
  String get displayName {
    switch (this) {
      case SensorType.suhu:
        return 'Temperature';
      case SensorType.kelembapan:
        return 'Kelembapan';
      case SensorType.ph:
        return 'pH';
      case SensorType.cahaya:
        return 'Cahaya';
      case SensorType.tekanan:
        return 'Tekanan Udara';
    }
  }

  String get defaultUnit {
    switch (this) {
      case SensorType.suhu:
        return '°C';
      case SensorType.kelembapan:
        return '%';
      case SensorType.ph:
        return 'pH';
      case SensorType.cahaya:
        return 'lux';
      case SensorType.tekanan:
        return 'hPa';
    }
  }
}

extension SensorStatusExtension on SensorStatus {
  String get displayName {
    switch (this) {
      case SensorStatus.normal:
        return 'Normal';
      case SensorStatus.peringatan:
        return 'Peringatan';
      case SensorStatus.tinggi:
        return 'Tinggi';
      case SensorStatus.rendah:
        return 'Rendah';
      case SensorStatus.nonaktif:
        return 'Nonaktif';
    }
  }
}

class SensorModel {
  final String id;
  final String name;
  final String location;
  final SensorType type;
  final String unit;
  final double minNormal;
  final double maxNormal;
  final bool isActive;
  final String? notes;
  final double? currentValue;
  final SensorStatus? currentStatus;
  final DateTime? lastUpdated;

  SensorModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.unit,
    required this.minNormal,
    required this.maxNormal,
    this.isActive = true,
    this.notes,
    this.currentValue,
    this.currentStatus,
    this.lastUpdated,
  });

  SensorModel copyWith({
    String? id,
    String? name,
    String? location,
    SensorType? type,
    String? unit,
    double? minNormal,
    double? maxNormal,
    bool? isActive,
    String? notes,
    double? currentValue,
    SensorStatus? currentStatus,
    DateTime? lastUpdated,
  }) {
    return SensorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      type: type ?? this.type,
      unit: unit ?? this.unit,
      minNormal: minNormal ?? this.minNormal,
      maxNormal: maxNormal ?? this.maxNormal,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      currentValue: currentValue ?? this.currentValue,
      currentStatus: currentStatus ?? this.currentStatus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Calculate status based on current value and normal range
  SensorStatus calculateStatus() {
    if (!isActive) return SensorStatus.nonaktif;
    if (currentValue == null) return SensorStatus.nonaktif;

    if (currentValue! < minNormal) {
      return SensorStatus.rendah;
    } else if (currentValue! > maxNormal) {
      return SensorStatus.tinggi;
    } else if (currentValue! >= minNormal && currentValue! <= maxNormal) {
      // Check if near boundaries (within 10% of range)
      final range = maxNormal - minNormal;
      final lowerWarning = minNormal + (range * 0.1);
      final upperWarning = maxNormal - (range * 0.1);

      if (currentValue! < lowerWarning || currentValue! > upperWarning) {
        return SensorStatus.peringatan;
      }
      return SensorStatus.normal;
    }
    return SensorStatus.normal;
  }
}
