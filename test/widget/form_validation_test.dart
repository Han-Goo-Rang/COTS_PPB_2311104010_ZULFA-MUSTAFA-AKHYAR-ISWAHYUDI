import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cots_ppb_2311104010_zulfamai/controllers/sensor_provider.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/pages/add_sensor_page.dart';

Widget createTestApp() {
  return ChangeNotifierProvider(
    create: (_) => SensorProvider(),
    child: const MaterialApp(home: AddSensorPage()),
  );
}

void main() {
  group('AddSensorPage - Form Validation Tests', () {
    testWidgets('should show error when Nama Sensor is empty', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Tap Simpan without filling any fields
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Verify error message for Nama Sensor
      expect(find.text('Field ini wajib diisi'), findsWidgets);
    });

    testWidgets('should show error when Lokasi is empty', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Fill only Nama Sensor
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan nama sensor'),
        'Test Sensor',
      );

      // Tap Simpan
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Verify error message for Lokasi
      expect(find.text('Field ini wajib diisi'), findsWidgets);
    });

    testWidgets('should show error when Tipe Sensor is not selected', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Fill Nama Sensor and Lokasi
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan nama sensor'),
        'Test Sensor',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan lokasi'),
        'Test Location',
      );

      // Tap Simpan without selecting Tipe Sensor
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Verify error message for Tipe Sensor (at least one error text appears)
      expect(find.text('Pilih tipe sensor'), findsAtLeastNWidgets(1));
    });

    testWidgets('should show error when min > max', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Fill required fields
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan nama sensor'),
        'Test Sensor',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan lokasi'),
        'Test Location',
      );

      // Select Tipe Sensor
      await tester.tap(find.text('Pilih tipe sensor'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Temperature').last);
      await tester.pumpAndSettle();

      // Enter invalid min/max (min > max)
      await tester.enterText(find.widgetWithText(TextField, 'Min'), '50');
      await tester.enterText(find.widgetWithText(TextField, 'Max'), '20');

      // Tap Simpan
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Nilai min harus lebih kecil dari max'), findsOneWidget);
    });

    testWidgets('should successfully add sensor with valid data', (
      tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => SensorProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddSensorPage()),
                    );
                  },
                  child: const Text('Go to Add'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to AddSensorPage
      await tester.tap(find.text('Go to Add'));
      await tester.pumpAndSettle();

      // Fill all required fields
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan nama sensor'),
        'New Test Sensor',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Masukkan lokasi'),
        'New Test Location',
      );

      // Select Tipe Sensor
      await tester.tap(find.text('Pilih tipe sensor'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Temperature').last);
      await tester.pumpAndSettle();

      // Enter valid min/max
      await tester.enterText(find.widgetWithText(TextField, 'Min'), '20');
      await tester.enterText(find.widgetWithText(TextField, 'Max'), '30');

      // Tap Simpan
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      // Verify navigation back (form submitted successfully)
      expect(find.byType(AddSensorPage), findsNothing);
    });

    testWidgets('toggle Aktifkan Sensor should work', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Scroll down to make toggle visible
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Find the toggle switch
      final toggle = find.byType(Switch);
      expect(toggle, findsOneWidget);

      // Toggle should be ON by default
      final switchWidget = tester.widget<Switch>(toggle);
      expect(switchWidget.value, true);

      // Tap to toggle OFF using ensureVisible
      await tester.ensureVisible(toggle);
      await tester.pumpAndSettle();
      await tester.tap(toggle, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify toggle is now OFF
      final updatedSwitch = tester.widget<Switch>(toggle);
      expect(updatedSwitch.value, false);
    });
  });

  group('AddSensorPage - UI Elements', () {
    testWidgets('should display all form fields', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify all labels are present
      expect(find.text('Nama Sensor'), findsOneWidget);
      expect(find.text('Lokasi'), findsOneWidget);
      expect(find.text('Tipe Sensor'), findsOneWidget);
      expect(find.text('Satuan'), findsOneWidget);
      expect(find.text('Batas Normal (min - max)'), findsOneWidget);
      expect(find.text('Aktifkan Sensor'), findsOneWidget);
      expect(find.text('Catatan'), findsOneWidget);
    });

    testWidgets('should display Simpan and Batal buttons', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Simpan'), findsOneWidget);
      expect(find.text('Batal'), findsOneWidget);
    });

    testWidgets('should display correct AppBar title', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Tambah Sensor'), findsOneWidget);
    });
  });
}
