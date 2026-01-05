import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cots_ppb_2311104010_zulfamai/controllers/sensor_provider.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/pages/monitoring_page.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/pages/sensor_list_page.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/pages/sensor_detail_page.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/pages/add_sensor_page.dart';
import 'package:cots_ppb_2311104010_zulfamai/presentation/pages/data_history_page.dart';

Widget createTestApp(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => SensorProvider(),
    child: MaterialApp(home: child),
  );
}

void main() {
  group('Navigation Tests', () {
    testWidgets('MonitoringPage should navigate to SensorListPage', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const MonitoringPage()));
      await tester.pumpAndSettle();

      // Find and tap "Daftar Sensor" link
      final daftarSensorLink = find.text('Daftar Sensor');
      expect(daftarSensorLink, findsOneWidget);

      await tester.tap(daftarSensorLink);
      await tester.pumpAndSettle();

      // Verify navigation to SensorListPage
      expect(find.byType(SensorListPage), findsOneWidget);
    });

    testWidgets('MonitoringPage should navigate to AddSensorPage', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const MonitoringPage()));
      await tester.pumpAndSettle();

      // Find and tap "Tambah Sensor" button
      final tambahButton = find.text('Tambah Sensor');
      expect(tambahButton, findsOneWidget);

      await tester.tap(tambahButton);
      await tester.pumpAndSettle();

      // Verify navigation to AddSensorPage
      expect(find.byType(AddSensorPage), findsOneWidget);
    });

    testWidgets('SensorListPage should navigate back to previous page', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const SensorListPage()));
      await tester.pumpAndSettle();

      // Find back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets('SensorListPage should navigate to AddSensorPage via Tambah', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(const SensorListPage()));
      await tester.pumpAndSettle();

      // Find and tap "Tambah" link in AppBar
      final tambahLink = find.text('Tambah');
      expect(tambahLink, findsOneWidget);

      await tester.tap(tambahLink);
      await tester.pumpAndSettle();

      // Verify navigation to AddSensorPage
      expect(find.byType(AddSensorPage), findsOneWidget);
    });

    testWidgets('SensorDetailPage should have back navigation', (tester) async {
      await tester.pumpWidget(
        createTestApp(const SensorDetailPage(sensorId: '1')),
      );
      await tester.pumpAndSettle();

      // Find back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets('SensorDetailPage should navigate to DataHistoryPage', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(const SensorDetailPage(sensorId: '1')),
      );
      await tester.pumpAndSettle();

      // Find and tap "Lihat Riwayat Data" button
      final riwayatButton = find.text('Lihat Riwayat Data');
      expect(riwayatButton, findsOneWidget);

      await tester.tap(riwayatButton);
      await tester.pumpAndSettle();

      // Verify navigation to DataHistoryPage
      expect(find.byType(DataHistoryPage), findsOneWidget);
    });

    testWidgets('DataHistoryPage should have back navigation', (tester) async {
      await tester.pumpWidget(
        createTestApp(const DataHistoryPage(sensorId: '1')),
      );
      await tester.pumpAndSettle();

      // Find back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets('AddSensorPage should have back navigation', (tester) async {
      await tester.pumpWidget(createTestApp(const AddSensorPage()));
      await tester.pumpAndSettle();

      // Find back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets('AddSensorPage Batal button should navigate back', (
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

      // Verify we're on AddSensorPage
      expect(find.byType(AddSensorPage), findsOneWidget);

      // Tap Batal button
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.byType(AddSensorPage), findsNothing);
    });
  });
}
