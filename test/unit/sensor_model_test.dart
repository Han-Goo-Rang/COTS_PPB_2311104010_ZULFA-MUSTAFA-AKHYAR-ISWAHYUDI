import 'package:flutter_test/flutter_test.dart';
import 'package:cots_ppb_2311104010_zulfamai/models/sensor_model.dart';

void main() {
  group('SensorModel', () {
    test('should create sensor with required properties', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test Sensor',
        location: 'Test Location',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
      );

      expect(sensor.id, '1');
      expect(sensor.name, 'Test Sensor');
      expect(sensor.location, 'Test Location');
      expect(sensor.type, SensorType.suhu);
      expect(sensor.unit, '°C');
      expect(sensor.minNormal, 20.0);
      expect(sensor.maxNormal, 30.0);
      expect(sensor.isActive, true); // default value
    });

    test('copyWith should create new instance with updated values', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Original',
        location: 'Location A',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
      );

      final updated = sensor.copyWith(name: 'Updated', isActive: false);

      expect(updated.name, 'Updated');
      expect(updated.isActive, false);
      expect(updated.id, '1'); // unchanged
      expect(updated.location, 'Location A'); // unchanged
    });

    test('calculateStatus should return nonaktif when sensor is inactive', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Loc',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: false,
        currentValue: 25.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.nonaktif);
    });

    test('calculateStatus should return rendah when value below minNormal', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Loc',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 15.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.rendah);
    });

    test('calculateStatus should return tinggi when value above maxNormal', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Loc',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 35.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.tinggi);
    });

    test('calculateStatus should return normal when value in safe range', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Loc',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 25.0, // middle of range
      );

      expect(sensor.calculateStatus(), SensorStatus.normal);
    });
  });

  group('SensorType Extension', () {
    test('displayName should return correct names', () {
      expect(SensorType.suhu.displayName, 'Temperature');
      expect(SensorType.kelembapan.displayName, 'Kelembapan');
      expect(SensorType.ph.displayName, 'pH');
      expect(SensorType.cahaya.displayName, 'Cahaya');
      expect(SensorType.tekanan.displayName, 'Tekanan Udara');
    });

    test('defaultUnit should return correct units', () {
      expect(SensorType.suhu.defaultUnit, '°C');
      expect(SensorType.kelembapan.defaultUnit, '%');
      expect(SensorType.ph.defaultUnit, 'pH');
      expect(SensorType.cahaya.defaultUnit, 'lux');
      expect(SensorType.tekanan.defaultUnit, 'hPa');
    });
  });

  group('SensorStatus Extension', () {
    test('displayName should return correct status names', () {
      expect(SensorStatus.normal.displayName, 'Normal');
      expect(SensorStatus.peringatan.displayName, 'Peringatan');
      expect(SensorStatus.tinggi.displayName, 'Tinggi');
      expect(SensorStatus.rendah.displayName, 'Rendah');
      expect(SensorStatus.nonaktif.displayName, 'Nonaktif');
    });
  });
}
