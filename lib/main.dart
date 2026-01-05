import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'design_system/colors.dart';
import 'controllers/sensor_provider.dart';
import 'presentation/pages/monitoring_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = SensorProvider();
  await provider.initialize();
  runApp(MyApp(provider: provider));
}

class MyApp extends StatelessWidget {
  final SensorProvider provider;

  const MyApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: 'Sensor Monitoring',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            surface: AppColors.background,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.elevated,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
          useMaterial3: true,
        ),
        home: const MonitoringPage(),
      ),
    );
  }
}
