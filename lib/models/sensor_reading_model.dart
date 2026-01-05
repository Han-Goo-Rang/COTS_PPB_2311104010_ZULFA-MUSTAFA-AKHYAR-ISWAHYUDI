import 'sensor_model.dart';

class SensorReadingModel {
  final String id;
  final String sensorId;
  final double value;
  final SensorStatus status;
  final DateTime timestamp;

  SensorReadingModel({
    required this.id,
    required this.sensorId,
    required this.value,
    required this.status,
    required this.timestamp,
  });

  SensorReadingModel copyWith({
    String? id,
    String? sensorId,
    double? value,
    SensorStatus? status,
    DateTime? timestamp,
  }) {
    return SensorReadingModel(
      id: id ?? this.id,
      sensorId: sensorId ?? this.sensorId,
      value: value ?? this.value,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
