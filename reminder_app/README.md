# 📋 Pembagian Tugas TaskZilla

Dokumen ini memastikan pembagian tugas yang **adil, terukur, dan mudah dilacak di GitHub**. Setiap anggota memiliki "wilayah kekuasaan" masing-masing dengan beban kerja yang seimbang antara UI dan logika.

## 📑 Daftar Isi

- [Ringkasan Tim](#-ringkasan-tim)
- [Struktur Folder](#-struktur-folder)
- [Kepemilikan Folder](#-kepemilikan-folder)
- [Detail Tanggung Jawab per Anggota](#-detail-tanggung-jawab-per-anggota)
- [Catatan Penting](#️-catatan-penting)
- [Timeline Implementasi](#-timeline-implementasi)

---

## 👥 Ringkasan Tim

| Anggota | NIM | Role | Fokus Utama |
|---------|-----|------|-------------|
| **Aliyah Tasya Ashifah** | 125 | Frontend Lead & UI Kit | Tema, Widget Reusable, Dashboard, Task, Splash |
| **Laili Nurul Fadila** | 013 | Frontend & User Flow | Auth, Profile, History, Form Tugas |
| **Laudya Aulia Putri** | 042 | Backend Lead & PM | Models, Firestore Service, Task & Category Provider |
| **Bintoro Amansyah** | 004 | Backend Logic | Auth Service, Notifications, Priority Calculator |
| **Alya Ramadhani** | 144 | System Analyst & Config | Constants, Utils, Config, Documentation |
| **Delavanti Gogumo** | 177 | QA & DevOps | Testing, Tools, Build, Git Management |

---

## 📁 Struktur Folder

Kode PIC pada tree: **ALY** = Aliyah, **LAI** = Laili, **LAU** = Laudya, **BIN** = Bintoro, **ALY-R** = Alya, **DEL** = Delavanti.

```text
taskzilla/
├── lib/
│   ├── main.dart                        # Entry point (Firebase + MultiProvider)
│   ├── firebase_options.dart            # Auto-generated Firebase config
│   │
│   ├── app/                             # Konfigurasi global aplikasi → Aliyah
│   │   ├── routes/
│   │   │   └── app_routes.dart          # Navigasi antar halaman
│   │   └── theme/
│   │       └── app_theme.dart           # Tema Teal, font, UI Kit
│   │
│   ├── config/                          # System analyst assets → Alya
│   │   ├── feature_flags.dart           # Toggle fitur MVP vs Future
│   │   └── requirements.md              # Catatan analisis kebutuhan teknis
│   │
│   ├── core/
│   │   ├── constants/                   # Terjemahan Figma ke kode → Alya
│   │   │   ├── app_colors.dart          # Kode warna hex dari Figma
│   │   │   ├── app_strings.dart         # Teks statis aplikasi
│   │   │   └── app_sizes.dart           # Padding/margin standar
│   │   ├── utils/                       # Logika helper → Alya & Bintoro
│   │   │   ├── email_validator.dart     # Validasi domain .ac.id        [Alya]
│   │   │   ├── date_formatter.dart      # Format deadline & countdown   [Alya]
│   │   │   └── priority_calculator.dart # Skor prioritas otomatis       [Bintoro]
│   │   └── widgets/                     # Widget reusable → Aliyah
│   │       ├── custom_button.dart       # Tombol standar TaskZilla
│   │       ├── custom_textfield.dart    # Input form dengan validasi
│   │       ├── task_card.dart           # Kartu tugas (Dashboard/Riwayat)
│   │       ├── priority_badge.dart      # Label Urgent/High/Medium/Low
│   │       └── loading_indicator.dart   # Animasi loading global
│   │
│   ├── models/                          # Schema data Firestore → Laudya
│   │   ├── user_model.dart              # Profil mahasiswa
│   │   ├── task_model.dart              # Data tugas utama
│   │   ├── category_model.dart          # Kategori (Individu/Kelompok/dll)
│   │   ├── checklist_model.dart         # Sub-tugas
│   │   └── notification_model.dart      # Data notifikasi/reminder
│   │
│   ├── services/                        # Logika Firebase/API → Laudya & Bintoro
│   │   ├── auth_service.dart            # Login/Register/Logout (.ac.id) [Bintoro]
│   │   ├── firestore_service.dart       # CRUD Tasks, Categories, Users  [Laudya]
│   │   ├── fcm_service.dart             # Push notification handler      [Bintoro]
│   │   └── local_notification.dart      # Reminder H-3, H-2, H-1         [Bintoro]
│   │
│   ├── providers/                       # State management → Laudya & Bintoro
│   │   ├── auth_provider.dart           # Status login/user data         [Bintoro]
│   │   ├── task_provider.dart           # List tasks, filter, search     [Laudya]
│   │   ├── category_provider.dart       # List kategori global           [Laudya]
│   │   └── notification_provider.dart   # Badge count, unread list       [Bintoro]
│   │
│   └── features/                        # UI layar berdasarkan fitur
│       ├── splash/                      # → Aliyah
│       │   └── splash_screen.dart       # Layar pembuka + mascot Dino
│       ├── auth/                        # → Laili
│       │   ├── login_screen.dart        # Form login + validasi
│       │   ├── register_screen.dart     # Form daftar + cek .ac.id
│       │   └── widgets/
│       │       └── auth_form_helper.dart
│       ├── dashboard/                   # → Aliyah
│       │   ├── dashboard_screen.dart    # Beranda + statistik + filter
│       │   └── widgets/
│       │       ├── summary_card.dart    # Ringkasan To Do/In Progress
│       │       └── filter_bar.dart      # Filter kategori/difficulty
│       ├── task/                        # → Aliyah
│       │   ├── add_task_screen.dart     # Form tambah tugas + Smart Alarm
│       │   ├── edit_task_screen.dart    # Edit detail tugas
│       │   ├── task_detail_screen.dart  # Detail + checklist + countdown
│       │   └── widgets/
│       │       ├── task_form.dart       # Reusable form input tugas
│       │       └── checklist_item.dart  # Widget sub-tugas
│       ├── history/                     # → Laili
│       │   ├── history_screen.dart      # Riwayat selesai + grafik
│       │   └── widgets/
│       │       ├── productivity_chart.dart  # Grafik batang mingguan
│       │       └── completed_task_card.dart
│       ├── notification/                # → Bintoro
│       │   └── notification_screen.dart # Daftar reminder deadline
│       └── profile/                     # → Laili
│           ├── profile_screen.dart      # Info akun + statistik pribadi
│           └── widgets/
│               └── settings_tile.dart   # Toggle Dark Mode, Notifikasi
│
├── test/                                # Quality assurance → Delavanti
│   ├── unit/
│   │   ├── auth_service_test.dart       # Test validasi email & password
│   │   └── priority_calculator_test.dart# Test logika skor prioritas
│   └── widget/
│       ├── login_screen_test.dart       # Test interaksi form login
│       └── task_card_test.dart          # Test rendering kartu tugas
│
├── tools/                               # DevOps automation → Delavanti
│   ├── check_lint.sh                    # Cek kualitas kode sebelum commit
│   └── build_apk.sh                     # Build APK release
│
└── docs/                                # Dokumentasi teknis → Alya & Delavanti
    ├── api_reference.md                 # Referensi endpoint Firestore
    ├── database_schema.md               # Visualisasi relasi collection
    ├── CONTRIBUTING.md                  # Panduan kontribusi tim
    └── weekly_report.md                 # Laporan progres mingguan
```

---

## 🗂️ Kepemilikan Folder

| Folder | PIC | Tanggung Jawab |
|--------|-----|----------------|
| `lib/app/` | Aliyah | Rute navigasi & tema global sesuai desain Figma (warna Teal, tipografi, UI Kit) |
| `lib/config/` | Alya | Feature flags & dokumentasi kebutuhan teknis sistem |
| `lib/core/constants/` | Alya | Penerjemahan desain Figma ke kode (warna, teks, ukuran) |
| `lib/core/utils/` | Alya & Bintoro | Alya: `email_validator`, `date_formatter` · Bintoro: `priority_calculator` |
| `lib/core/widgets/` | Aliyah | Widget reusable seluruh aplikasi |
| `lib/models/` | Laudya | Struktur data sesuai skema Firestore, lengkap dengan `fromFirestore()` & `toFirestore()` |
| `lib/services/` | Laudya & Bintoro | Laudya: `firestore_service` · Bintoro: `auth_service`, `fcm_service`, `local_notification` |
| `lib/providers/` | Laudya & Bintoro | Laudya: `task_provider`, `category_provider` · Bintoro: `auth_provider`, `notification_provider` |
| `lib/features/splash/` | Aliyah | Layar pembuka + mascot Dino |
| `lib/features/auth/` | Laili | Login & register dengan validasi |
| `lib/features/dashboard/` | Aliyah | Beranda, statistik, filter |
| `lib/features/task/` | Aliyah | Tambah, edit, dan detail tugas |
| `lib/features/history/` | Laili | Riwayat tugas selesai & grafik produktivitas |
| `lib/features/notification/` | Bintoro | Daftar reminder deadline |
| `lib/features/profile/` | Laili | Info akun & pengaturan |
| `test/` | Delavanti | Unit test & widget test, target coverage minimal **70%** |
| `tools/` | Delavanti | Script lint check & build APK |
| `docs/` | Alya & Delavanti | Dokumentasi teknis proyek |

---

## 📊 Detail Tanggung Jawab per Anggota

### 1. Aliyah Tasya Ashifah (125) — Frontend Lead & UI Kit

| File/Folder | Deskripsi |
|-------------|-----------|
| `lib/app/routes/app_routes.dart` | Konfigurasi navigasi antar halaman |
| `lib/app/theme/app_theme.dart` | Tema global (warna Teal, font, UI Kit) |
| `lib/core/widgets/` | Semua widget reusable (button, textfield, card, badge, loading) |
| `lib/features/splash/splash_screen.dart` | Layar pembuka dengan mascot Dino |
| `lib/features/dashboard/` | Halaman beranda, statistik, filter |
| `lib/features/task/` | Form tambah/edit/detail tugas |

**🎯 Output:** UI Kit konsisten, widget reusable, layar inti sesuai Figma.

### 2. Laili Nurul Fadila (013) — Frontend & User Flow

| File/Folder | Deskripsi |
|-------------|-----------|
| `lib/features/auth/` | Layar login & register dengan validasi |
| `lib/features/history/` | Riwayat tugas selesai & grafik produktivitas |
| `lib/features/profile/` | Profil pengguna & pengaturan |

**🎯 Output:** Flow autentikasi aman, halaman riwayat interaktif, form profil.

### 3. Laudya Aulia Putri (042) — Backend Lead & PM

| File/Folder | Deskripsi |
|-------------|-----------|
| `lib/models/` | Semua model data (user, task, category, checklist, notification) |
| `lib/services/firestore_service.dart` | CRUD untuk Tasks, Categories, Users |
| `lib/providers/task_provider.dart` | State management list tasks, filter, search |
| `lib/providers/category_provider.dart` | State management kategori global |

**🎯 Output:** Integrasi Firestore mulus, struktur data NoSQL, state management tugas.

### 4. Bintoro Amansyah (004) — Backend Logic

| File/Folder | Deskripsi |
|-------------|-----------|
| `lib/services/auth_service.dart` | Login, Register, Logout dengan validasi .ac.id |
| `lib/services/fcm_service.dart` | Firebase Cloud Messaging handler |
| `lib/services/local_notification.dart` | Reminder H-3, H-2, H-1 |
| `lib/providers/auth_provider.dart` | State management auth & user data |
| `lib/providers/notification_provider.dart` | Badge count & unread list |
| `lib/core/utils/priority_calculator.dart` | Algoritma perhitungan skor prioritas |
| `lib/features/notification/` | Layar daftar reminder deadline |

**🎯 Output:** Sistem Auth & Notifikasi aktif, algoritma prioritas akurat.

### 5. Alya Ramadhani (144) — System Analyst & Config

| File/Folder | Deskripsi |
|-------------|-----------|
| `lib/config/` | Feature flags & dokumentasi kebutuhan teknis |
| `lib/core/constants/` | App colors, strings, sizes (terjemahan Figma ke kode) |
| `lib/core/utils/email_validator.dart` | Validasi domain .ac.id |
| `lib/core/utils/date_formatter.dart` | Format deadline & countdown |
| `docs/` | Dokumentasi API, schema database, contributing guide |

**🎯 Output:** Constants terstruktur, validator & formatter fungsional, dokumentasi lengkap.

### 6. Delavanti Gogumo (177) — QA & DevOps

| File/Folder | Deskripsi |
|-------------|-----------|
| `test/unit/` | Unit test untuk auth service & priority calculator |
| `test/widget/` | Widget test untuk login screen & task card |
| `tools/` | Script automation (lint check, build APK) |
| `docs/CONTRIBUTING.md` | Panduan kontribusi tim (kolaborasi dengan Alya) |

**🎯 Output:** Unit & widget tests, script CI/CD dasar, build APK final, Git management.

---

## ⚠️ Catatan Penting

### 1. File `.gitkeep` untuk Folder Kosong

Git tidak menyimpan folder kosong. **Wajib** buat file `.gitkeep` di setiap folder yang masih kosong sebelum push agar struktur tidak hilang di GitHub.

```powershell
# PowerShell (Windows)
New-Item -Path "lib/app/routes" -Name ".gitkeep" -Force
New-Item -Path "lib/app/theme" -Name ".gitkeep" -Force
New-Item -Path "lib/config" -Name ".gitkeep" -Force
New-Item -Path "lib/core/constants" -Name ".gitkeep" -Force
New-Item -Path "lib/core/utils" -Name ".gitkeep" -Force
New-Item -Path "lib/core/widgets" -Name ".gitkeep" -Force
New-Item -Path "lib/models" -Name ".gitkeep" -Force
New-Item -Path "lib/services" -Name ".gitkeep" -Force
New-Item -Path "lib/providers" -Name ".gitkeep" -Force
New-Item -Path "lib/features/splash" -Name ".gitkeep" -Force
New-Item -Path "lib/features/auth/widgets" -Name ".gitkeep" -Force
New-Item -Path "lib/features/dashboard/widgets" -Name ".gitkeep" -Force
New-Item -Path "lib/features/task/widgets" -Name ".gitkeep" -Force
New-Item -Path "lib/features/history/widgets" -Name ".gitkeep" -Force
New-Item -Path "lib/features/notification" -Name ".gitkeep" -Force
New-Item -Path "lib/features/profile/widgets" -Name ".gitkeep" -Force
New-Item -Path "test/unit" -Name ".gitkeep" -Force
New-Item -Path "test/widget" -Name ".gitkeep" -Force
New-Item -Path "tools" -Name ".gitkeep" -Force
New-Item -Path "docs" -Name ".gitkeep" -Force
```

### 2. Branching Strategy

| Branch | Fungsi |
|--------|--------|
| `main` | Production ready |
| `develop` | Integration branch |
| `feature/[nama-fitur]-[nama]` | Development per anggota |

### 3. Commit Message Convention

| Prefix | Kegunaan |
|--------|----------|
| `feat:` | Menambah fitur baru |
| `fix:` | Memperbaiki bug |
| `docs:` | Update dokumentasi |
| `style:` | Perbaikan format kode |
| `test:` | Menambah/memperbaiki test |
| `refactor:` | Refactoring kode |

### 4. Aturan Kontribusi

Setiap anggota wajib:

- [x] Memiliki kontribusi pada repository
- [x] Memahami struktur project
- [x] Memahami fitur yang dikerjakan
- [x] Mampu menjelaskan kode yang dibuat
- [x] Mampu melakukan debugging sederhana
- [x] Mampu menjelaskan hubungan antara frontend, API, dan database

---

## 🎯 Timeline Implementasi

| Minggu | Fokus | PIC Utama |
|:------:|-------|-----------|
| 1 | Setup project, struktur folder, `.gitkeep` | Semua anggota |
| 2 | `core/constants/`, `app/theme/`, `models/` | Alya, Aliyah, Laudya |
| 3 | `services/auth_service.dart`, `features/auth/` | Bintoro, Laili |
| 4 | `providers/`, `features/dashboard/` | Laudya, Bintoro, Aliyah |
| 5 | `features/task/`, `core/widgets/` | Aliyah |
| 6 | `features/history/`, `features/profile/` | Laili |
| 7 | `services/fcm_service.dart`, `services/local_notification.dart`, `features/notification/` | Bintoro |
| 8 | `test/`, `tools/`, integrasi & testing | Delavanti, Semua anggota |
| 9 | Bug fixing, UI polish, dokumentasi | Semua anggota |
| 10 | Build APK, final testing, deployment | Delavanti, Laudya |
