import 'package:flutter_test/flutter_test.dart';
import 'package:cots_ppb_2311104010_zulfamai/controllers/sensor_provider.dart';
import 'package:cots_ppb_2311104010_zulfamai/models/sensor_model.dart';

void main() {
  late SensorProvider provider;

  setUp(() {
    provider = SensorProvider();
  });

  group('SensorProvider - Initial State', () {
    test('should have mock data on initialization', () {
      expect(provider.sensors.isNotEmpty, true);
      expect(provider.totalSensorCount, greaterThan(0));
    });

    test('should have 5 initial sensors', () {
      expect(provider.totalSensorCount, 5);
    });
  });

  group('SensorProvider - Getters', () {
    test('activeSensors should return only active sensors', () {
      final activeSensors = provider.activeSensors;
      for (final sensor in activeSensors) {
        expect(sensor.isActive, true);
      }
    });

    test('warningSensors should return sensors with warning status', () {
      final warningSensors = provider.warningSensors;
      for (final sensor in warningSensors) {
        expect(
          sensor.currentStatus == SensorStatus.peringatan ||
              sensor.currentStatus == SensorStatus.tinggi ||
              sensor.currentStatus == SensorStatus.rendah,
          true,
        );
      }
    });

    test('totalSensorCount should match sensors length', () {
      expect(provider.totalSensorCount, provider.sensors.length);
    });

    test('activeSensorCount should match activeSensors length', () {
      expect(provider.activeSensorCount, provider.activeSensors.length);
    });

    test('warningCount should match warningSensors length', () {
      expect(provider.warningCount, provider.warningSensors.length);
    });
  });

  group('SensorProvider - Add Sensor', () {
    test('addSensor should increase sensor count', () {
      final initialCount = provider.totalSensorCount;

      final newSensor = SensorModel(
        id: 'new_1',
        name: 'New Sensor',
        location: 'New Location',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
      );

      provider.addSensor(newSensor);

      expect(provider.totalSensorCount, initialCount + 1);
    });

    test('addSensor should make sensor retrievable by id', () {
      final newSensor = SensorModel(
        id: 'test_sensor_123',
        name: 'Test Sensor',
        location: 'Test Location',
        type: SensorType.kelembapan,
        unit: '%',
        minNormal: 40.0,
        maxNormal: 60.0,
      );

      provider.addSensor(newSensor);

      final retrieved = provider.getSensorById('test_sensor_123');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Test Sensor');
    });
  });

  group('SensorProvider - Update Sensor Status', () {
    test('updateSensorStatus should change isActive property', () {
      final sensor = provider.sensors.first;
      final originalStatus = sensor.isActive;

      provider.updateSensorStatus(sensor.id, !originalStatus);

      final updated = provider.getSensorById(sensor.id);
      expect(updated!.isActive, !originalStatus);
    });

    test('updateSensorStatus with false should set status to nonaktif', () {
      final sensor = provider.sensors.first;

      provider.updateSensorStatus(sensor.id, false);

      final updated = provider.getSensorById(sensor.id);
      expect(updated!.currentStatus, SensorStatus.nonaktif);
    });
  });

  group('SensorProvider - Get Sensor By ID', () {
    test('getSensorById should return sensor when exists', () {
      final sensor = provider.getSensorById('1');
      expect(sensor, isNotNull);
      expect(sensor!.id, '1');
    });

    test('getSensorById should return null when not exists', () {
      final sensor = provider.getSensorById('non_existent_id');
      expect(sensor, isNull);
    });
  });

  group('SensorProvider - Filter Sensors', () {
    test('filterSensors with semua should return all sensors', () {
      final filtered = provider.filterSensors(SensorFilter.semua);
      expect(filtered.length, provider.totalSensorCount);
    });

    test('filterSensors with aktif should return only active sensors', () {
      final filtered = provider.filterSensors(SensorFilter.aktif);
      for (final sensor in filtered) {
        expect(sensor.isActive, true);
      }
    });

    test('filterSensors with nonaktif should return only inactive sensors', () {
      // First deactivate a sensor
      provider.updateSensorStatus('1', false);

      final filtered = provider.filterSensors(SensorFilter.nonaktif);
      for (final sensor in filtered) {
        expect(sensor.isActive, false);
      }
    });

    test('filterSensors with peringatan should return warning sensors', () {
      final filtered = provider.filterSensors(SensorFilter.peringatan);
      for (final sensor in filtered) {
        expect(
          sensor.currentStatus == SensorStatus.peringatan ||
              sensor.currentStatus == SensorStatus.tinggi ||
              sensor.currentStatus == SensorStatus.rendah,
          true,
        );
      }
    });
  });

  group('SensorProvider - Search Sensors', () {
    test('searchSensors with empty query should return all sensors', () {
      final results = provider.searchSensors('');
      expect(results.length, provider.totalSensorCount);
    });

    test('searchSensors should find by name (case insensitive)', () {
      final results = provider.searchSensors('suhu');
      expect(results.isNotEmpty, true);
      expect(results.any((s) => s.name.toLowerCase().contains('suhu')), true);
    });

    test('searchSensors should find by location (case insensitive)', () {
      final results = provider.searchSensors('greenhouse');
      expect(results.isNotEmpty, true);
      expect(
        results.any((s) => s.location.toLowerCase().contains('greenhouse')),
        true,
      );
    });

    test('searchSensors with non-matching query should return empty', () {
      final results = provider.searchSensors('xyz_not_found_123');
      expect(results.isEmpty, true);
    });
  });

  group('SensorProvider - Get Readings', () {
    test('getReadingsForSensor should return readings for valid sensor', () {
      final readings = provider.getReadingsForSensor('1');
      expect(readings.isNotEmpty, true);
    });

    test('getReadingsForSensor should return empty for invalid sensor', () {
      final readings = provider.getReadingsForSensor('non_existent');
      expect(readings.isEmpty, true);
    });

    test('getReadingsForSensor should return sorted by timestamp desc', () {
      final readings = provider.getReadingsForSensor('1');
      if (readings.length > 1) {
        for (int i = 0; i < readings.length - 1; i++) {
          expect(
            readings[i].timestamp.isAfter(readings[i + 1].timestamp) ||
                readings[i].timestamp.isAtSameMomentAs(
                  readings[i + 1].timestamp,
                ),
            true,
          );
        }
      }
    });
  });

  group('SensorProvider - Delete Sensor', () {
    test('deleteSensor should remove sensor from list', () {
      final initialCount = provider.totalSensorCount;

      provider.deleteSensor('1');

      expect(provider.totalSensorCount, initialCount - 1);
      expect(provider.getSensorById('1'), isNull);
    });

    test('deleteSensor should also remove associated readings', () {
      provider.deleteSensor('1');

      final readings = provider.getReadingsForSensor('1');
      expect(readings.isEmpty, true);
    });
  });
}
