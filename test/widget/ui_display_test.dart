import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cots_ppb_2311104010_zulfamai/models/sensor_model.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/widgets/status_badge.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/widgets/summary_card.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/widgets/sensor_card.dart';

void main() {
  group('StatusBadge Widget Tests', () {
    Widget createStatusBadge(SensorStatus status, {bool isCompact = false}) {
      return MaterialApp(
        home: Scaffold(
          body: StatusBadge(status: status, isCompact: isCompact),
        ),
      );
    }

    testWidgets('displays Normal status correctly', (tester) async {
      await tester.pumpWidget(createStatusBadge(SensorStatus.normal));
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('displays Peringatan status correctly', (tester) async {
      await tester.pumpWidget(createStatusBadge(SensorStatus.peringatan));
      expect(find.text('Peringatan'), findsOneWidget);
    });

    testWidgets('displays Tinggi status correctly', (tester) async {
      await tester.pumpWidget(createStatusBadge(SensorStatus.tinggi));
      expect(find.text('Tinggi'), findsOneWidget);
    });

    testWidgets('displays Rendah status correctly', (tester) async {
      await tester.pumpWidget(createStatusBadge(SensorStatus.rendah));
      expect(find.text('Rendah'), findsOneWidget);
    });

    testWidgets('displays Nonaktif status correctly', (tester) async {
      await tester.pumpWidget(createStatusBadge(SensorStatus.nonaktif));
      expect(find.text('Nonaktif'), findsOneWidget);
    });
  });

  group('SummaryCard Widget Tests', () {
    Widget createSummaryCard({
      required IconData icon,
      required String label,
      required int count,
      required Color color,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              SummaryCard(icon: icon, label: label, count: count, color: color),
            ],
          ),
        ),
      );
    }

    testWidgets('displays count and label correctly', (tester) async {
      await tester.pumpWidget(
        createSummaryCard(
          icon: Icons.sensors,
          label: 'Total Sensor',
          count: 5,
          color: Colors.blue,
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.text('Total Sensor'), findsOneWidget);
      expect(find.byIcon(Icons.sensors), findsOneWidget);
    });

    testWidgets('displays zero count', (tester) async {
      await tester.pumpWidget(
        createSummaryCard(
          icon: Icons.warning,
          label: 'Peringatan',
          count: 0,
          color: Colors.orange,
        ),
      );

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Peringatan'), findsOneWidget);
    });
  });

  group('SensorCard Widget Tests', () {
    Widget createSensorCard({
      String name = 'Sensor Suhu 01',
      String location = 'Greenhouse A',
      String value = '27.4',
      String unit = '°C',
      SensorStatus status = SensorStatus.normal,
      String timestamp = '18 Jan 2026, 10:15',
      bool isCompact = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SensorCard(
            name: name,
            location: location,
            value: value,
            unit: unit,
            status: status,
            timestamp: timestamp,
            isCompact: isCompact,
            onTap: onTap,
          ),
        ),
      );
    }

    testWidgets('displays all sensor information', (tester) async {
      await tester.pumpWidget(createSensorCard());

      expect(find.text('Sensor Suhu 01'), findsOneWidget);
      expect(find.text('Greenhouse A'), findsOneWidget);
      expect(find.text('27.4'), findsOneWidget);
      expect(find.text('°C'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('18 Jan 2026, 10:15'), findsOneWidget);
    });

    testWidgets('displays warning status', (tester) async {
      await tester.pumpWidget(
        createSensorCard(name: 'Sensor pH', status: SensorStatus.peringatan),
      );

      expect(find.text('Sensor pH'), findsOneWidget);
      expect(find.text('Peringatan'), findsOneWidget);
    });

    testWidgets('handles tap callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createSensorCard(onTap: () => tapped = true));

      await tester.tap(find.byType(SensorCard));
      expect(tapped, isTrue);
    });

    testWidgets('displays compact layout', (tester) async {
      await tester.pumpWidget(createSensorCard(isCompact: true));

      expect(find.text('Sensor Suhu 01'), findsOneWidget);
      expect(find.text('Greenhouse A'), findsOneWidget);
    });

    testWidgets('displays waiting message when no value', (tester) async {
      await tester.pumpWidget(createSensorCard(value: '-'));

      expect(find.text('Menunggu data...'), findsOneWidget);
    });
  });

  group('SensorCard.fromModel Tests', () {
    testWidgets('creates card from SensorModel', (tester) async {
      final sensor = SensorModel(
        id: '1',
        name: 'Kelembapan Tanah',
        location: 'Ladang B',
        type: SensorType.kelembapan,
        unit: '%',
        minNormal: 40.0,
        maxNormal: 60.0,
        isActive: true,
        currentValue: 45.0,
        currentStatus: SensorStatus.normal,
        lastUpdated: DateTime(2026, 1, 18, 10, 12),
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SensorCard.fromModel(sensor))),
      );

      expect(find.text('Kelembapan Tanah'), findsOneWidget);
      expect(find.text('Ladang B'), findsOneWidget);
      expect(find.text('45.0'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
    });
  });

  group('SensorModel Tests', () {
    test('calculateStatus returns normal for value in range', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Test',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 25.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.normal);
    });

    test('calculateStatus returns tinggi for value above max', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Test',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 35.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.tinggi);
    });

    test('calculateStatus returns rendah for value below min', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Test',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: true,
        currentValue: 15.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.rendah);
    });

    test('calculateStatus returns nonaktif when inactive', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Test',
        location: 'Test',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
        isActive: false,
        currentValue: 25.0,
      );

      expect(sensor.calculateStatus(), SensorStatus.nonaktif);
    });

    test('copyWith creates new instance with updated values', () {
      final sensor = SensorModel(
        id: '1',
        name: 'Original',
        location: 'Location A',
        type: SensorType.suhu,
        unit: '°C',
        minNormal: 20.0,
        maxNormal: 30.0,
      );

      final updated = sensor.copyWith(name: 'Updated', location: 'Location B');

      expect(updated.name, 'Updated');
      expect(updated.location, 'Location B');
      expect(updated.id, '1'); // unchanged
      expect(updated.type, SensorType.suhu); // unchanged
    });
  });

  group('SensorType Extension Tests', () {
    test('displayName returns correct names', () {
      expect(SensorType.suhu.displayName, 'Temperature');
      expect(SensorType.kelembapan.displayName, 'Kelembapan');
      expect(SensorType.ph.displayName, 'pH');
      expect(SensorType.cahaya.displayName, 'Cahaya');
      expect(SensorType.tekanan.displayName, 'Tekanan Udara');
    });

    test('defaultUnit returns correct units', () {
      expect(SensorType.suhu.defaultUnit, '°C');
      expect(SensorType.kelembapan.defaultUnit, '%');
      expect(SensorType.ph.defaultUnit, 'pH');
      expect(SensorType.cahaya.defaultUnit, 'lux');
      expect(SensorType.tekanan.defaultUnit, 'hPa');
    });
  });

  group('SensorStatus Extension Tests', () {
    test('displayName returns correct names', () {
      expect(SensorStatus.normal.displayName, 'Normal');
      expect(SensorStatus.peringatan.displayName, 'Peringatan');
      expect(SensorStatus.tinggi.displayName, 'Tinggi');
      expect(SensorStatus.rendah.displayName, 'Rendah');
      expect(SensorStatus.nonaktif.displayName, 'Nonaktif');
    });
  });
}
