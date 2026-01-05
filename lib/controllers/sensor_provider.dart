import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/sensor_model.dart';
import '../models/sensor_reading_model.dart';

enum SensorFilter { semua, aktif, nonaktif, peringatan }

class SensorProvider extends ChangeNotifier {
  List<SensorModel> _sensors = [];
  List<SensorReadingModel> _readings = [];
  late SharedPreferences _prefs;

  static const String _sensorsKey = 'sensors';
  static const String _readingsKey = 'readings';

  SensorProvider() {
    _initializeMockData();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      final sensorsJson = _prefs.getString(_sensorsKey);
      final readingsJson = _prefs.getString(_readingsKey);

      if (sensorsJson != null) {
        final List<dynamic> decoded = jsonDecode(sensorsJson);
        _sensors = decoded.map((item) => _sensorFromJson(item)).toList();
      } else {
        _initializeMockData();
        await _saveData();
      }

      if (readingsJson != null) {
        final List<dynamic> decoded = jsonDecode(readingsJson);
        _readings = decoded.map((item) => _readingFromJson(item)).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
      _initializeMockData();
    }
  }

  Future<void> _saveData() async {
    try {
      final sensorsJson = jsonEncode(
        _sensors.map((s) => _sensorToJson(s)).toList(),
      );
      final readingsJson = jsonEncode(
        _readings.map((r) => _readingToJson(r)).toList(),
      );

      await _prefs.setString(_sensorsKey, sensorsJson);
      await _prefs.setString(_readingsKey, readingsJson);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Map<String, dynamic> _sensorToJson(SensorModel sensor) {
    return {
      'id': sensor.id,
      'name': sensor.name,
      'location': sensor.location,
      'type': sensor.type.toString().split('.').last,
      'unit': sensor.unit,
      'minNormal': sensor.minNormal,
      'maxNormal': sensor.maxNormal,
      'isActive': sensor.isActive,
      'notes': sensor.notes,
      'currentValue': sensor.currentValue,
      'currentStatus': sensor.currentStatus?.toString().split('.').last,
      'lastUpdated': sensor.lastUpdated?.toIso8601String(),
    };
  }

  SensorModel _sensorFromJson(Map<String, dynamic> json) {
    return SensorModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      type: SensorType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      unit: json['unit'],
      minNormal: json['minNormal'],
      maxNormal: json['maxNormal'],
      isActive: json['isActive'],
      notes: json['notes'],
      currentValue: json['currentValue'],
      currentStatus: json['currentStatus'] != null
          ? SensorStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['currentStatus'],
            )
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> _readingToJson(SensorReadingModel reading) {
    return {
      'id': reading.id,
      'sensorId': reading.sensorId,
      'value': reading.value,
      'status': reading.status.toString().split('.').last,
      'timestamp': reading.timestamp.toIso8601String(),
    };
  }

  SensorReadingModel _readingFromJson(Map<String, dynamic> json) {
    return SensorReadingModel(
      id: json['id'],
      sensorId: json['sensorId'],
      value: json['value'],
      status: SensorStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Getters
  List<SensorModel> get sensors => List.unmodifiable(_sensors);

  List<SensorModel> get activeSensors =>
      _sensors.where((s) => s.isActive).toList();

  List<SensorModel> get warningSensors => _sensors
      .where(
        (s) =>
            s.currentStatus == SensorStatus.peringatan ||
            s.currentStatus == SensorStatus.tinggi ||
            s.currentStatus == SensorStatus.rendah,
      )
      .toList();

  int get totalSensorCount => _sensors.length;

  int get activeSensorCount => activeSensors.length;

  int get warningCount => warningSensors.length;

  List<SensorReadingModel> get readings => List.unmodifiable(_readings);

  // Methods
  void addSensor(SensorModel sensor) {
    _sensors.add(sensor);

    // Generate dummy readings for the new sensor
    _generateDummyReadings(sensor);

    _saveData();
    notifyListeners();
  }

  void _generateDummyReadings(SensorModel sensor) {
    final now = DateTime.now();
    final range = sensor.maxNormal - sensor.minNormal;

    // Generate 8 dummy readings over the past few hours
    for (int i = 0; i < 8; i++) {
      // Generate random value within and slightly outside normal range
      final randomFactor = (now.millisecond + i * 17) % 100 / 100;
      final extendedMin = sensor.minNormal - (range * 0.1);
      final extendedMax = sensor.maxNormal + (range * 0.1);
      final value = extendedMin + (extendedMax - extendedMin) * randomFactor;

      // Calculate status based on value
      SensorStatus status;
      if (value < sensor.minNormal) {
        status = SensorStatus.rendah;
      } else if (value > sensor.maxNormal) {
        status = SensorStatus.tinggi;
      } else {
        final lowerWarning = sensor.minNormal + (range * 0.1);
        final upperWarning = sensor.maxNormal - (range * 0.1);
        if (value < lowerWarning || value > upperWarning) {
          status = SensorStatus.peringatan;
        } else {
          status = SensorStatus.normal;
        }
      }

      _readings.add(
        SensorReadingModel(
          id: '${sensor.id}_r$i',
          sensorId: sensor.id,
          value: double.parse(value.toStringAsFixed(1)),
          status: status,
          timestamp: now.subtract(Duration(minutes: 15 * i)),
        ),
      );
    }
  }

  void updateSensor(SensorModel sensor) {
    final index = _sensors.indexWhere((s) => s.id == sensor.id);
    if (index != -1) {
      _sensors[index] = sensor;
      _saveData();
      notifyListeners();
    }
  }

  void updateSensorStatus(String sensorId, bool isActive) {
    final index = _sensors.indexWhere((s) => s.id == sensorId);
    if (index != -1) {
      final sensor = _sensors[index];

      // Calculate new status based on isActive and current value
      SensorStatus newStatus;
      if (!isActive) {
        newStatus = SensorStatus.nonaktif;
      } else if (sensor.currentValue == null) {
        newStatus = SensorStatus.normal;
      } else {
        // Calculate status based on current value and normal range
        if (sensor.currentValue! < sensor.minNormal) {
          newStatus = SensorStatus.rendah;
        } else if (sensor.currentValue! > sensor.maxNormal) {
          newStatus = SensorStatus.tinggi;
        } else {
          // Check if near boundaries (within 10% of range)
          final range = sensor.maxNormal - sensor.minNormal;
          final lowerWarning = sensor.minNormal + (range * 0.1);
          final upperWarning = sensor.maxNormal - (range * 0.1);

          if (sensor.currentValue! < lowerWarning ||
              sensor.currentValue! > upperWarning) {
            newStatus = SensorStatus.peringatan;
          } else {
            newStatus = SensorStatus.normal;
          }
        }
      }

      _sensors[index] = sensor.copyWith(
        isActive: isActive,
        currentStatus: newStatus,
      );
      _saveData();
      notifyListeners();
    }
  }

  void deleteSensor(String sensorId) {
    _sensors.removeWhere((s) => s.id == sensorId);
    _readings.removeWhere((r) => r.sensorId == sensorId);
    _saveData();
    notifyListeners();
  }

  SensorModel? getSensorById(String sensorId) {
    try {
      return _sensors.firstWhere((s) => s.id == sensorId);
    } catch (e) {
      return null;
    }
  }

  List<SensorReadingModel> getReadingsForSensor(String sensorId) {
    return _readings.where((r) => r.sensorId == sensorId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<SensorModel> filterSensors(SensorFilter filter) {
    switch (filter) {
      case SensorFilter.semua:
        return List.unmodifiable(_sensors);
      case SensorFilter.aktif:
        return _sensors.where((s) => s.isActive).toList();
      case SensorFilter.nonaktif:
        return _sensors.where((s) => !s.isActive).toList();
      case SensorFilter.peringatan:
        return _sensors
            .where(
              (s) =>
                  s.currentStatus == SensorStatus.peringatan ||
                  s.currentStatus == SensorStatus.tinggi ||
                  s.currentStatus == SensorStatus.rendah,
            )
            .toList();
    }
  }

  List<SensorModel> searchSensors(String query) {
    if (query.isEmpty) return List.unmodifiable(_sensors);

    final lowerQuery = query.toLowerCase();
    return _sensors
        .where(
          (s) =>
              s.name.toLowerCase().contains(lowerQuery) ||
              s.location.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  List<SensorModel> searchAndFilterSensors(String query, SensorFilter filter) {
    var result = filterSensors(filter);

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      result = result
          .where(
            (s) =>
                s.name.toLowerCase().contains(lowerQuery) ||
                s.location.toLowerCase().contains(lowerQuery),
          )
          .toList();
    }

    return result;
  }

  void _initializeMockData() {
    _sensors = [
      SensorModel(
        id: '1',
        name: 'Sensor Suhu 01',
        location: 'Greenhouse A',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 27.4,
        currentStatus: SensorStatus.normal,
        lastUpdated: DateTime(2026, 1, 18, 10, 15),
      ),
      SensorModel(
        id: '2',
        name: 'Kelembapan Tanah 02',
        location: 'Ladang B',
        type: SensorType.kelembapan,
        unit: '%',
        minNormal: 40.0,
        maxNormal: 60.0,
        isActive: true,
        currentValue: 45.0,
        currentStatus: SensorStatus.normal,
        lastUpdated: DateTime(2026, 1, 18, 10, 12),
      ),
      SensorModel(
        id: '3',
        name: 'Sensor pH Air 03',
        location: 'Akuaponik C',
        type: SensorType.ph,
        unit: 'pH',
        minNormal: 6.5,
        maxNormal: 7.5,
        isActive: true,
        currentValue: 6.2,
        currentStatus: SensorStatus.peringatan,
        lastUpdated: DateTime(2026, 1, 18, 10, 8),
      ),
      SensorModel(
        id: '4',
        name: 'Sensor Cahaya 04',
        location: 'Gedung D',
        type: SensorType.cahaya,
        unit: 'lux',
        minNormal: 300.0,
        maxNormal: 800.0,
        isActive: true,
        currentValue: 520.0,
        currentStatus: SensorStatus.normal,
        lastUpdated: DateTime(2026, 1, 18, 10, 5),
      ),
      SensorModel(
        id: '5',
        name: 'Tekanan Udara 05',
        location: 'Lab E',
        type: SensorType.tekanan,
        unit: 'hPa',
        minNormal: 1000.0,
        maxNormal: 1020.0,
        isActive: true,
        currentValue: 1013.0,
        currentStatus: SensorStatus.normal,
        lastUpdated: DateTime(2026, 1, 18, 10, 0),
      ),
    ];

    // Generate mock readings for all sensors
    _readings = [];

    // Sensor Suhu 01 readings
    _readings.addAll([
      SensorReadingModel(
        id: 'r1_1',
        sensorId: '1',
        value: 27.4,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 15),
      ),
      SensorReadingModel(
        id: 'r1_2',
        sensorId: '1',
        value: 27.2,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 0),
      ),
      SensorReadingModel(
        id: 'r1_3',
        sensorId: '1',
        value: 28.1,
        status: SensorStatus.tinggi,
        timestamp: DateTime(2026, 1, 18, 9, 45),
      ),
      SensorReadingModel(
        id: 'r1_4',
        sensorId: '1',
        value: 26.9,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 30),
      ),
      SensorReadingModel(
        id: 'r1_5',
        sensorId: '1',
        value: 25.8,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 15),
      ),
      SensorReadingModel(
        id: 'r1_6',
        sensorId: '1',
        value: 19.5,
        status: SensorStatus.rendah,
        timestamp: DateTime(2026, 1, 18, 9, 0),
      ),
    ]);

    // Kelembapan Tanah 02 readings (40-60% normal range)
    _readings.addAll([
      SensorReadingModel(
        id: 'r2_1',
        sensorId: '2',
        value: 45.0,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 12),
      ),
      SensorReadingModel(
        id: 'r2_2',
        sensorId: '2',
        value: 48.3,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 0),
      ),
      SensorReadingModel(
        id: 'r2_3',
        sensorId: '2',
        value: 52.1,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 45),
      ),
      SensorReadingModel(
        id: 'r2_4',
        sensorId: '2',
        value: 58.7,
        status: SensorStatus.peringatan,
        timestamp: DateTime(2026, 1, 18, 9, 30),
      ),
      SensorReadingModel(
        id: 'r2_5',
        sensorId: '2',
        value: 62.4,
        status: SensorStatus.tinggi,
        timestamp: DateTime(2026, 1, 18, 9, 15),
      ),
      SensorReadingModel(
        id: 'r2_6',
        sensorId: '2',
        value: 55.2,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 0),
      ),
      SensorReadingModel(
        id: 'r2_7',
        sensorId: '2',
        value: 38.1,
        status: SensorStatus.rendah,
        timestamp: DateTime(2026, 1, 18, 8, 45),
      ),
    ]);

    // Sensor pH Air 03 readings (6.5-7.5 normal range)
    _readings.addAll([
      SensorReadingModel(
        id: 'r3_1',
        sensorId: '3',
        value: 6.2,
        status: SensorStatus.peringatan,
        timestamp: DateTime(2026, 1, 18, 10, 8),
      ),
      SensorReadingModel(
        id: 'r3_2',
        sensorId: '3',
        value: 6.8,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 0),
      ),
      SensorReadingModel(
        id: 'r3_3',
        sensorId: '3',
        value: 7.1,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 45),
      ),
      SensorReadingModel(
        id: 'r3_4',
        sensorId: '3',
        value: 7.6,
        status: SensorStatus.tinggi,
        timestamp: DateTime(2026, 1, 18, 9, 30),
      ),
      SensorReadingModel(
        id: 'r3_5',
        sensorId: '3',
        value: 7.0,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 15),
      ),
      SensorReadingModel(
        id: 'r3_6',
        sensorId: '3',
        value: 6.4,
        status: SensorStatus.rendah,
        timestamp: DateTime(2026, 1, 18, 9, 0),
      ),
    ]);

    // Sensor Cahaya 04 readings (300-800 lux normal range)
    _readings.addAll([
      SensorReadingModel(
        id: 'r4_1',
        sensorId: '4',
        value: 520.0,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 5),
      ),
      SensorReadingModel(
        id: 'r4_2',
        sensorId: '4',
        value: 485.5,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 0),
      ),
      SensorReadingModel(
        id: 'r4_3',
        sensorId: '4',
        value: 612.3,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 45),
      ),
      SensorReadingModel(
        id: 'r4_4',
        sensorId: '4',
        value: 780.0,
        status: SensorStatus.peringatan,
        timestamp: DateTime(2026, 1, 18, 9, 30),
      ),
      SensorReadingModel(
        id: 'r4_5',
        sensorId: '4',
        value: 850.2,
        status: SensorStatus.tinggi,
        timestamp: DateTime(2026, 1, 18, 9, 15),
      ),
      SensorReadingModel(
        id: 'r4_6',
        sensorId: '4',
        value: 290.5,
        status: SensorStatus.rendah,
        timestamp: DateTime(2026, 1, 18, 9, 0),
      ),
      SensorReadingModel(
        id: 'r4_7',
        sensorId: '4',
        value: 445.8,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 8, 45),
      ),
    ]);

    // Tekanan Udara 05 readings (1000-1020 hPa normal range)
    _readings.addAll([
      SensorReadingModel(
        id: 'r5_1',
        sensorId: '5',
        value: 1013.0,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 10, 0),
      ),
      SensorReadingModel(
        id: 'r5_2',
        sensorId: '5',
        value: 1010.5,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 45),
      ),
      SensorReadingModel(
        id: 'r5_3',
        sensorId: '5',
        value: 1008.2,
        status: SensorStatus.normal,
        timestamp: DateTime(2026, 1, 18, 9, 30),
      ),
      SensorReadingModel(
        id: 'r5_4',
        sensorId: '5',
        value: 1018.7,
        status: SensorStatus.peringatan,
        timestamp: DateTime(2026, 1, 18, 9, 15),
      ),
      SensorReadingModel(
        id: 'r5_5',
        sensorId: '5',
        value: 1022.3,
        status: SensorStatus.tinggi,
        timestamp: DateTime(2026, 1, 18, 9, 0),
      ),
      SensorReadingModel(
        id: 'r5_6',
        sensorId: '5',
        value: 998.1,
        status: SensorStatus.rendah,
        timestamp: DateTime(2026, 1, 18, 8, 45),
      ),
    ]);
  }
}
