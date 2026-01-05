# Sensor Monitoring App

## Overview

Aplikasi Flutter untuk monitoring sensor yang memungkinkan pengguna melihat data sensor secara real-time, mengelola daftar sensor, melihat detail dan riwayat data sensor, serta menambah sensor baru.

## Fitur Utama

- Dashboard monitoring dengan ringkasan sensor
- Daftar sensor dengan filter dan pencarian
- Detail sensor dengan toggle aktif/nonaktif
- Riwayat data pembacaan sensor
- Form tambah sensor baru

## Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── config/
│   └── routes.dart           # Konfigurasi routing
├── controllers/
│   └── sensor_provider.dart  # State management (Provider)
├── design_system/
│   ├── colors.dart           # Palet warna
│   ├── typography.dart       # Style teks
│   └── spacing.dart          # Spacing & elevation
├── models/
│   ├── sensor_model.dart     # Model data sensor
│   └── sensor_reading_model.dart
├── presentation/
│   ├── pages/                # 5 halaman utama
│   └── widgets/              # Komponen UI reusable
└── services/
```

## Tech Stack

- Flutter/Dart
- Provider (State Management)
- Design System dengan 8pt grid

---

Dibuat oleh: Zulfa Mai (2311104010)
