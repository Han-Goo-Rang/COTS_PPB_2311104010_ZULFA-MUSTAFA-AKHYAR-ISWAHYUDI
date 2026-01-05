# Implementation Plan: Sensor Monitoring App

## Overview

Implementasi aplikasi Flutter Sensor Monitoring dengan 5 halaman utama, design system yang konsisten, dan state management menggunakan Provider. Tasks disusun secara incremental untuk memastikan setiap langkah dapat divalidasi.

## Tasks

- [x] 1. Setup project structure and design system

  - [x] 1.1 Create folder structure (design_system/, models/, presentation/pages/, presentation/widgets/, controllers/, services/, config/)
    - Create all required directories under lib/
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_
  - [x] 1.2 Implement AppColors in design_system/colors.dart
    - Define all color constants: primary, secondary, success, warning, danger, background, elevated, textPrimary, textSecondary
    - _Requirements: 1.1_
  - [x] 1.3 Implement AppTypography in design_system/typography.dart
    - Define text styles: title, section, body, caption, button
    - _Requirements: 1.2_
  - [x] 1.4 Implement AppSpacing in design_system/spacing.dart
    - Define spacing constants: grid, radius, cardPadding, shadows, buttonHeight
    - _Requirements: 1.3, 1.4_

- [x] 2. Implement data models

  - [x] 2.1 Create SensorModel in models/sensor_model.dart
    - Define SensorModel class with all properties (id, name, location, type, unit, minNormal, maxNormal, isActive, notes, currentValue, currentStatus, lastUpdated)
    - Define SensorType enum (suhu, kelembapan, ph, cahaya, tekanan)
    - Define SensorStatus enum (normal, peringatan, tinggi, rendah, nonaktif)
    - _Requirements: 4.1, 6.1-6.7_
  - [x] 2.2 Create SensorReadingModel in models/sensor_reading_model.dart
    - Define SensorReadingModel class with properties (id, sensorId, value, status, timestamp)
    - _Requirements: 5.4_

- [x] 3. Implement state management with Provider

  - [x] 3.1 Create SensorProvider in controllers/sensor_provider.dart
    - Implement ChangeNotifier with sensor list state
    - Implement addSensor method
    - Implement updateSensorStatus method
    - Implement getSensorById method
    - Implement getReadingsForSensor method
    - Implement filterSensors method
    - Implement searchSensors method
    - Add mock/dummy data for initial sensors
    - _Requirements: 7.1, 7.2, 7.3, 7.4_
  - [ ]\* 3.2 Write property test for filter functionality
    - **Property 3: Filter Produces Correct Subset**
    - **Validates: Requirements 3.3**
  - [ ]\* 3.3 Write property test for add sensor functionality
    - **Property 6: Add Sensor Updates State**
    - **Validates: Requirements 6.10, 7.2**
  - [ ]\* 3.4 Write property test for toggle status functionality
    - **Property 4: Toggle Updates Sensor Status**
    - **Validates: Requirements 4.4, 7.3**
  - [ ]\* 3.5 Write property test for search functionality
    - **Property 7: Search Filters by Name or Location**
    - **Validates: Requirements 3.1**

- [x] 4. Implement reusable widgets

  - [x] 4.1 Create StatusBadge widget in presentation/widgets/status_badge.dart
    - Display status text with appropriate background color based on SensorStatus
    - Support compact mode for list items
    - _Requirements: 9.5, 2.6, 2.7_
  - [x] 4.2 Create CustomButton widget in presentation/widgets/custom_button.dart
    - Support primary and secondary variants
    - Support full width option
    - Apply design system colors and typography
    - _Requirements: 9.2_
  - [x] 4.3 Create CustomInput widget in presentation/widgets/custom_input.dart
    - Support label and placeholder
    - Support error text display
    - Apply design system styling
    - _Requirements: 9.3_
  - [x] 4.4 Create CustomToggle widget in presentation/widgets/custom_toggle.dart
    - Support label display
    - Apply design system colors
    - _Requirements: 9.4_
  - [x] 4.5 Create SummaryCard widget in presentation/widgets/summary_card.dart
    - Display icon, label, and count
    - Apply design system elevation and colors
    - _Requirements: 9.1, 2.1_
  - [x] 4.6 Create SensorCard widget in presentation/widgets/sensor_card.dart
    - Display sensor name, location, value, unit, status badge, timestamp
    - Support onTap callback for navigation
    - Apply design system elevation and spacing
    - _Requirements: 9.1, 2.3, 3.4_
  - [ ]\* 4.7 Write property test for SensorCard data completeness
    - **Property 2: Sensor Card Data Completeness**
    - **Validates: Requirements 2.3**

- [x] 5. Checkpoint - Verify foundation components

  - Ensure all design system files compile without errors
  - Ensure all models are properly defined
  - Ensure Provider is properly configured
  - Ensure all widgets render correctly
  - Ask the user if questions arise

- [x] 6. Implement Monitoring Page (Home)

  - [x] 6.1 Create MonitoringPage in presentation/pages/monitoring_page.dart
    - Implement AppBar with title "Monitoring Sensor" and "Daftar Sensor" link
    - Display 3 SummaryCards in horizontal row (Total Sensor, Sensor Aktif, Peringatan)
    - Display "Data Terbaru" section header with timestamp
    - Display list of SensorCards with latest readings from Provider
    - Add "Tambah Sensor" button at bottom
    - Wire up navigation to SensorListPage and AddSensorPage
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 8.1, 8.2_
  - [ ]\* 6.2 Write property test for summary counts
    - **Property 1: Summary Counts Match State**
    - **Validates: Requirements 2.1**

- [x] 7. Implement Sensor List Page

  - [x] 7.1 Create SensorListPage in presentation/pages/sensor_list_page.dart
    - Implement AppBar with back button, title "Daftar Sensor", and "Tambah" link
    - Implement search bar with TextField
    - Implement filter chips (Semua, Aktif, Nonaktif, Peringatan)
    - Display filtered list of SensorCards
    - Wire up search and filter functionality with Provider
    - Wire up navigation to SensorDetailPage and AddSensorPage
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 8.3, 8.4_

- [x] 8. Implement Sensor Detail Page

  - [x] 8.1 Create SensorDetailPage in presentation/pages/sensor_detail_page.dart
    - Implement AppBar with back button, title "Detail Sensor", and "Edit" link
    - Display sensor info section (Nama Sensor, Lokasi, Tipe Sensor, Status)
    - Display large current value with unit
    - Implement "Pengaturan" section with "Sensor Aktif" toggle
    - Wire up toggle to update sensor status via Provider
    - Add "Lihat Riwayat Data" button
    - Wire up navigation to DataHistoryPage
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 8.5_

- [x] 9. Implement Data History Page

  - [x] 9.1 Create DataHistoryPage in presentation/pages/data_history_page.dart
    - Implement AppBar with back button and title "Riwayat Data"
    - Display sensor name at top
    - Implement "Rentang Tanggal" checkbox filter
    - Display list of historical readings with timestamp, value, and status badge
    - Get readings data from Provider
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [x] 10. Implement Add Sensor Page

  - [x] 10.1 Create AddSensorPage in presentation/pages/add_sensor_page.dart
    - Implement AppBar with back button and title "Tambah Sensor"
    - Implement form with all input fields:
      - Nama Sensor (CustomInput)
      - Lokasi (CustomInput)
      - Tipe Sensor (Dropdown)
      - Satuan (CustomInput with hint)
      - Batas Normal min-max (two CustomInputs)
      - Aktifkan Sensor (CustomToggle)
      - Catatan (TextArea)
    - Implement form validation for required fields
    - Implement "Simpan" button to add sensor via Provider
    - Implement "Batal" button to cancel
    - Wire up navigation back after save/cancel
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 6.10, 6.11, 6.12, 8.6_
  - [ ]\* 10.2 Write property test for form validation
    - **Property 5: Form Validation Correctness**
    - **Validates: Requirements 6.8, 6.9**

- [x] 11. Configure app routing and main.dart

  - [x] 11.1 Create routes configuration in config/routes.dart
    - Define route names as constants
    - _Requirements: 8.1-8.6_
  - [x] 11.2 Update main.dart
    - Configure Provider at app root
    - Set up MaterialApp with routes
    - Set MonitoringPage as home
    - Apply design system theme
    - _Requirements: 7.1, 7.4_

- [x] 12. Final checkpoint - Integration testing
  - Verify all navigation flows work correctly
  - Verify state updates propagate across pages
  - Verify form validation works
  - Verify UI matches design specifications
  - Ask the user if questions arise

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties
- Unit tests validate specific examples and edge cases
- Implementation uses Dart/Flutter with Provider for state management
