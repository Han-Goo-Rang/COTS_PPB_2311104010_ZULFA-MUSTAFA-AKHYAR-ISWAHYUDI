# Requirements Document

## Introduction

Aplikasi Flutter untuk monitoring sensor yang memungkinkan pengguna melihat data sensor secara real-time, mengelola daftar sensor, melihat detail dan riwayat data sensor, serta menambah sensor baru. Aplikasi menggunakan design system yang konsisten dengan state management menggunakan setState atau Provider.

## Glossary

- **Sensor**: Perangkat yang mengukur parameter lingkungan (suhu, kelembapan, pH, cahaya, tekanan udara)
- **Monitoring_Dashboard**: Halaman utama yang menampilkan ringkasan semua sensor dan data terbaru
- **Sensor_List**: Halaman daftar semua sensor dengan fitur filter dan pencarian
- **Sensor_Detail**: Halaman detail informasi sensor individual
- **Data_History**: Halaman riwayat data pembacaan sensor
- **Add_Sensor_Form**: Halaman formulir untuk menambah sensor baru
- **Design_System**: Kumpulan komponen UI standar (colors, typography, spacing)
- **Sensor_Status**: Status sensor (Normal, Peringatan, Tinggi, Rendah, Nonaktif)

## Requirements

### Requirement 1: Design System Implementation

**User Story:** As a developer, I want a consistent design system, so that the app has uniform styling across all pages.

#### Acceptance Criteria

1. THE Design_System SHALL define color palette with Primary (#2563EB), Secondary (#06B6D4), Success (#22C55E), Warning (#F59E0B), Danger (#EF4444), Background (#F5F7FB), Elevated (#FFFFFF), Text_Primary (#0F172A), Text_Secondary (#475569)
2. THE Design_System SHALL define typography with Title (22 SemiBold), Section (18 SemiBold), Body (14 Regular), Caption (13 Regular), Button (14 SemiBold)
3. THE Design_System SHALL define spacing tokens with 8pt grid, Radius 14, Card padding 16-20
4. THE Design_System SHALL define elevation with Card shadow (0 6 16), Floating shadow (0 10 24)
5. THE Design_System SHALL be stored in design_system/ folder containing colors.dart, typography.dart, and spacing.dart

### Requirement 2: Monitoring Dashboard Page

**User Story:** As a user, I want to see a dashboard with sensor overview, so that I can quickly monitor all sensors status.

#### Acceptance Criteria

1. WHEN the app launches, THE Monitoring_Dashboard SHALL display summary cards showing Total Sensor count, Sensor Aktif count, and Peringatan count
2. THE Monitoring_Dashboard SHALL display "Data Terbaru" section with latest sensor readings
3. WHEN displaying sensor data, THE Monitoring_Dashboard SHALL show sensor name, location, current value with unit, status badge (Normal/Peringatan/Tinggi/Rendah), and timestamp
4. THE Monitoring_Dashboard SHALL provide navigation to Daftar Sensor page via header link
5. THE Monitoring_Dashboard SHALL provide "Tambah Sensor" button at bottom for navigation to Add_Sensor_Form
6. WHEN a sensor status is Normal, THE Monitoring_Dashboard SHALL display green status badge
7. WHEN a sensor status is Peringatan, THE Monitoring_Dashboard SHALL display amber/orange status badge

### Requirement 3: Sensor List Page

**User Story:** As a user, I want to see a list of all sensors with filtering options, so that I can find and manage specific sensors.

#### Acceptance Criteria

1. THE Sensor_List SHALL display a search bar to filter sensors by name or location
2. THE Sensor_List SHALL display filter chips for status: Semua, Aktif, Nonaktif, Peringatan
3. WHEN a filter chip is selected, THE Sensor_List SHALL filter displayed sensors accordingly
4. THE Sensor_List SHALL display each sensor as a card with sensor name, location, timestamp, and status indicator
5. WHEN a sensor card is tapped, THE Sensor_List SHALL navigate to Sensor_Detail page
6. THE Sensor_List SHALL provide "Tambah" button in header for navigation to Add_Sensor_Form
7. THE Sensor_List SHALL provide back navigation to Monitoring_Dashboard

### Requirement 4: Sensor Detail Page

**User Story:** As a user, I want to see detailed information about a sensor, so that I can understand its configuration and current reading.

#### Acceptance Criteria

1. THE Sensor_Detail SHALL display sensor name, location, sensor type, and status
2. THE Sensor_Detail SHALL display current sensor value prominently with large typography
3. THE Sensor_Detail SHALL display "Pengaturan" section with "Sensor Aktif" toggle switch
4. WHEN the Sensor Aktif toggle is changed, THE Sensor_Detail SHALL update the sensor active status using state management
5. THE Sensor_Detail SHALL provide "Lihat Riwayat Data" button for navigation to Data_History
6. THE Sensor_Detail SHALL provide "Edit" button in header for editing sensor
7. THE Sensor_Detail SHALL provide back navigation to previous page

### Requirement 5: Data History Page

**User Story:** As a user, I want to see historical data readings from a sensor, so that I can analyze trends over time.

#### Acceptance Criteria

1. THE Data_History SHALL display sensor name at the top
2. THE Data_History SHALL provide date range filter with checkbox "Rentang Tanggal"
3. THE Data_History SHALL display list of historical readings with timestamp, value, and status badge
4. WHEN displaying historical data, THE Data_History SHALL show each entry with date, time, value with unit, and status (Normal/Peringatan/Tinggi/Rendah)
5. THE Data_History SHALL provide back navigation to Sensor_Detail

### Requirement 6: Add Sensor Form Page

**User Story:** As a user, I want to add new sensors to the system, so that I can expand my monitoring capabilities.

#### Acceptance Criteria

1. THE Add_Sensor_Form SHALL provide input field for "Nama Sensor" with placeholder text
2. THE Add_Sensor_Form SHALL provide input field for "Lokasi" with placeholder text
3. THE Add_Sensor_Form SHALL provide dropdown for "Tipe Sensor" selection
4. THE Add_Sensor_Form SHALL provide input field for "Satuan" with placeholder (e.g., "Otomatis (misal: °C)")
5. THE Add_Sensor_Form SHALL provide input fields for "Batas Normal (min - max)" with Min and Max fields
6. THE Add_Sensor_Form SHALL provide toggle switch for "Aktifkan Sensor"
7. THE Add_Sensor_Form SHALL provide text area for "Catatan" (optional)
8. WHEN user taps "Simpan" button, THE Add_Sensor_Form SHALL validate all required fields
9. IF validation fails, THEN THE Add_Sensor_Form SHALL display appropriate error messages
10. WHEN validation passes and Simpan is tapped, THE Add_Sensor_Form SHALL add the new sensor using state management and navigate back
11. THE Add_Sensor_Form SHALL provide "Batal" button to cancel and navigate back without saving
12. THE Add_Sensor_Form SHALL provide back navigation in header

### Requirement 7: State Management

**User Story:** As a developer, I want proper state management, so that sensor data is managed consistently across the app.

#### Acceptance Criteria

1. THE App SHALL use setState or Provider for local state management
2. WHEN a new sensor is added via Add_Sensor_Form, THE App SHALL update the sensor list state
3. WHEN sensor status is toggled in Sensor_Detail, THE App SHALL update the sensor active status in state
4. THE App SHALL maintain sensor list state accessible from Monitoring_Dashboard and Sensor_List

### Requirement 8: Navigation

**User Story:** As a user, I want smooth navigation between pages, so that I can easily access different features.

#### Acceptance Criteria

1. THE App SHALL implement navigation from Monitoring_Dashboard to Sensor_List via "Daftar Sensor" link
2. THE App SHALL implement navigation from Monitoring_Dashboard to Add_Sensor_Form via "Tambah Sensor" button
3. THE App SHALL implement navigation from Sensor_List to Sensor_Detail via sensor card tap
4. THE App SHALL implement navigation from Sensor_List to Add_Sensor_Form via "Tambah" button
5. THE App SHALL implement navigation from Sensor_Detail to Data_History via "Lihat Riwayat Data" button
6. THE App SHALL implement back navigation on all pages except Monitoring_Dashboard

### Requirement 9: Reusable UI Components

**User Story:** As a developer, I want reusable UI components, so that the codebase is maintainable and consistent.

#### Acceptance Criteria

1. THE App SHALL implement reusable Card widget following design system elevation and padding
2. THE App SHALL implement reusable Button widget with primary and secondary variants
3. THE App SHALL implement reusable Input widget with label and placeholder support
4. THE App SHALL implement reusable Checkbox widget
5. THE App SHALL implement reusable StatusBadge widget for displaying sensor status with appropriate colors
6. ALL reusable widgets SHALL be stored in presentation/widgets/ folder

### Requirement 10: Folder Structure

**User Story:** As a developer, I want organized folder structure, so that the codebase is maintainable.

#### Acceptance Criteria

1. THE App SHALL organize code in lib/ folder with subfolders: design_system/, models/, presentation/, controllers/, services/, config/
2. THE design_system/ folder SHALL contain colors.dart, typography.dart, spacing.dart
3. THE presentation/ folder SHALL contain pages/ and widgets/ subfolders
4. THE models/ folder SHALL contain sensor data model
5. THE presentation/pages/ folder SHALL contain all 5 main pages
