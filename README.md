# DOKUMENTASI APLIKASI SENSOR MONITORING

**Tugas Pemrograman Perangkat Bergerak (PPB)**  
**Nama:** Zulfa Mai | **NIM:** 2311104010

---

## 1. DESKRIPSI APLIKASI

Aplikasi Sensor Monitoring adalah aplikasi mobile berbasis Flutter yang dirancang untuk memantau berbagai jenis sensor secara real-time. Aplikasi ini memungkinkan pengguna untuk mengelola sensor, melihat data pembacaan terkini, menganalisis riwayat data, serta menambahkan sensor baru ke dalam sistem monitoring.

### Tujuan Aplikasi

- Menyediakan dashboard terpusat untuk monitoring seluruh sensor
- Memudahkan pengelolaan status sensor (aktif/nonaktif)
- Memberikan informasi status sensor dengan indikator visual (Normal, Peringatan, Tinggi, Rendah)
- Menyimpan dan menampilkan riwayat pembacaan sensor

---

## 2. FITUR UTAMA

| No  | Fitur                    | Deskripsi                                                                                                                                               |
| --- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **Dashboard Monitoring** | Menampilkan ringkasan total sensor, sensor aktif, dan sensor dalam status peringatan. Dilengkapi dengan data pembacaan terbaru dari semua sensor.       |
| 2   | **Daftar Sensor**        | Menampilkan seluruh sensor dengan fitur pencarian berdasarkan nama/lokasi dan filter berdasarkan status (Semua, Aktif, Nonaktif, Peringatan).           |
| 3   | **Detail Sensor**        | Menampilkan informasi lengkap sensor meliputi nama, lokasi, tipe, nilai pembacaan saat ini, serta pengaturan untuk mengaktifkan/menonaktifkan sensor.   |
| 4   | **Riwayat Data**         | Menampilkan histori pembacaan sensor dengan informasi timestamp, nilai, dan status pada setiap pembacaan. Mendukung filter berdasarkan rentang tanggal. |
| 5   | **Tambah Sensor**        | Form untuk menambahkan sensor baru dengan input nama, lokasi, tipe sensor, satuan, batas normal (min-max), dan catatan opsional.                        |

---

## 3. ARSITEKTUR & STRUKTUR PROJECT

Aplikasi menggunakan arsitektur yang terorganisir dengan pemisahan concern yang jelas:

```
lib/
├── main.dart                      # Entry point & konfigurasi Provider
├── config/
│   └── routes.dart                # Konstanta nama route navigasi
├── controllers/
│   └── sensor_provider.dart       # State management menggunakan Provider
├── design_system/
│   ├── colors.dart                # Palet warna (Primary, Success, Warning, dll)
│   ├── typography.dart            # Style teks (Title, Body, Caption, dll)
│   └── spacing.dart               # Spacing, radius, dan shadow
├── models/
│   ├── sensor_model.dart          # Model data sensor & enum SensorType/Status
│   └── sensor_reading_model.dart  # Model data pembacaan sensor
├── presentation/
│   ├── pages/                     # 5 halaman utama aplikasi
│   │   ├── monitoring_page.dart   # Halaman dashboard
│   │   ├── sensor_list_page.dart  # Halaman daftar sensor
│   │   ├── sensor_detail_page.dart# Halaman detail sensor
│   │   ├── data_history_page.dart # Halaman riwayat data
│   │   └── add_sensor_page.dart   # Halaman tambah sensor
│   └── widgets/                   # Komponen UI reusable
│       ├── sensor_card.dart       # Card untuk menampilkan info sensor
│       ├── summary_card.dart      # Card ringkasan di dashboard
│       ├── status_badge.dart      # Badge status sensor
│       ├── custom_button.dart     # Tombol dengan variant primary/secondary
│       ├── custom_input.dart      # Input field dengan label & validasi
│       └── custom_toggle.dart     # Toggle switch untuk pengaturan
└── services/                      # Layer untuk service eksternal (future)
```

---

## 4. TEKNOLOGI & DESIGN SYSTEM

### Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Provider (ChangeNotifier)
- **Target Platform:** Android, iOS, Web, Desktop

### Design System

| Komponen          | Spesifikasi                                                   |
| ----------------- | ------------------------------------------------------------- |
| **Warna Utama**   | Primary (#2563EB), Secondary (#06B6D4)                        |
| **Status Colors** | Success (#22C55E), Warning (#F59E0B), Danger (#EF4444)        |
| **Typography**    | Title (22 SemiBold), Section (18 SemiBold), Body (14 Regular) |
| **Spacing**       | 8pt grid system, Border Radius 14px, Card Padding 16-20px     |

### Tipe Sensor yang Didukung

- Suhu (°C)
- Kelembapan (%)
- pH
- Cahaya (lux)
- Tekanan Udara (hPa)

---

## 5. ALUR NAVIGASI

```
┌─────────────────────┐
│  Monitoring Page    │ ◄── Halaman Utama (Home)
│     (Dashboard)     │
└─────────┬───────────┘
          │
    ┌─────┴─────┐
    ▼           ▼
┌─────────┐  ┌─────────────┐
│ Daftar  │  │   Tambah    │
│ Sensor  │  │   Sensor    │
└────┬────┘  └─────────────┘
     │
     ▼
┌─────────────┐
│   Detail    │
│   Sensor    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Riwayat    │
│    Data     │
└─────────────┘
```

---

## 6. VALIDASI & STATE MANAGEMENT

### Validasi Form Tambah Sensor

- Nama Sensor: Wajib diisi
- Lokasi: Wajib diisi
- Tipe Sensor: Wajib dipilih
- Batas Normal: Min harus lebih kecil dari Max

### State Management dengan Provider

- Menyimpan daftar sensor dan pembacaan
- Mendukung operasi: tambah sensor, update status, filter, dan pencarian
- State tersinkronisasi di seluruh halaman aplikasi

---
Dibuat oleh:
Zulfa M.A.I (2311104010)
**© 2025 - Sensor Monitoring App | Telkom University**
