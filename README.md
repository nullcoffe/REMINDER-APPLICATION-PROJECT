# 📋 Pembagian Tugas TaskZilla

Dokumen ini memastikan pembagian tugas yang **adil, terukur, dan mudah dilacak di GitHub**. Setiap anggota memiliki "wilayah kekuasaan" masing-masing dengan beban kerja yang seimbang antara UI dan logika.

> **Status saat ini:** struktur folder & file placeholder sudah dibuat di `reminder_app/`. Tahap selanjutnya adalah mengisi tiap file sesuai PIC dan branch yang tertera di bawah.

## 📑 Daftar Isi

- [Ringkasan Tim](#-ringkasan-tim)
- [Struktur Folder](#-struktur-folder)
- [Kepemilikan Folder](#️-kepemilikan-folder)
- [Detail Tanggung Jawab per Anggota](#-detail-tanggung-jawab-per-anggota)
- [Branch yang Harus Dibuat per Anggota](#-branch-yang-harus-dibuat-per-anggota)
- [Panduan Membuat Branch](#-panduan-membuat-branch)
- [Catatan Penting](#️-catatan-penting)
- [Timeline Implementasi](#-timeline-implementasi)

---

## 👥 Ringkasan Tim

| Anggota                  | NIM | Role                    | Fokus Utama                                                                        |
| ------------------------ | --- | ----------------------- | ---------------------------------------------------------------------------------- |
| **Aliyah Tasya Ashifah** | 125 | Frontend Lead & UI Kit  | Tema, Routes, Widget Reusable, Splash, Dashboard, Task                             |
| **Laili Nurul Fadila**   | 013 | Frontend & User Flow    | Auth UI, History, Profile                                                          |
| **Laudya Aulia Putri**   | 042 | Backend Lead & PM       | Models, Service Firestore (task/category/checklist/user), Task & Category Provider |
| **Bintoro Amansyah**     | 004 | Backend Logic           | Auth Service, Notifikasi (FCM/Local/Service), Priority Calculator, Notification UI |
| **Alya Ramadhani**       | 144 | System Analyst & Config | Constants, Utils (validator/formatter), Config, Documentation                      |
| **Delavanti Gogumo**     | 177 | QA & DevOps             | Testing, Tools, Build, Git Management                                              |

---

## 📁 Struktur Folder

Kode PIC pada tree: **ALY** = Aliyah, **LAI** = Laili, **LAU** = Laudya, **BIN** = Bintoro, **ALYA** = Alya, **DEL** = Delavanti.

> Nama file di bawah **sesuai kondisi repository saat ini**. Tanda ⚠️ menandai nama yang typo dan perlu diperbaiki (lihat [Catatan Penting → Perapihan Nama](#1-perapihan-nama-typo--folder-duplikat)).

```text
REMINDER-APPLICATION-PROJECT/
└── reminder_app/
    ├── android/ · ios/ · web/           # Platform folder (auto-generated Flutter)
    ├── pubspec.yaml · pubspec.lock      # Dependency
    ├── analysis_options.yaml            # Aturan lint
    ├── firebase.json                    # Konfigurasi Firebase CLI
    │
    ├── lib/
    │   ├── main.dart                    # Entry point (Firebase + MultiProvider)
    │   ├── firebase_options.dart        # Auto-generated Firebase config
    │   │
    │   ├── app/                         # Konfigurasi global aplikasi → ALY
    │   │   ├── routes/
    │   │   │   └── app_routes.dart      # Navigasi antar halaman
    │   │   └── theme/
    │   │       └── app_theme.dart       # Tema Teal, font, UI Kit
    │   │
    │   ├── config/                      # System analyst assets → ALYA
    │   │   ├── feature_flags.dart       # Toggle fitur MVP vs Future
    │   │   └── requirements.md          # Catatan analisis kebutuhan teknis
    │   │
    │   ├── core/
    │   │   ├── constants/               # Terjemahan Figma ke kode → ALYA
    │   │   │   ├── app_colors.dart      # Kode warna hex dari Figma
    │   │   │   ├── app_sizes.dart       # Padding/margin standar
    │   │   │   └── app_strings.dart     # Teks statis aplikasi
    │   │   ├── utils/                   # Logika helper → ALYA & BIN
    │   │   │   ├── date_formatter.dart      # Format deadline & countdown   [ALYA]
    │   │   │   ├── email_validator.dart     # Validasi domain .ac.id        [ALYA]
    │   │   │   └── priority_calculator.dart # Skor prioritas otomatis       [BIN]
    │   │   └── widgets/                 # Widget reusable → ALY
    │   │       ├── costom_button.dart       # ⚠️ Tombol standar TaskZilla
    │   │       ├── costom_textfield.dart    # ⚠️ Input form dengan validasi
    │   │       ├── loading_inicator.dart    # ⚠️ Animasi loading global
    │   │       ├── priority_badge.dart      # Label Urgent/High/Medium/Low
    │   │       └── task_card.dart           # Kartu tugas (Dashboard/Riwayat)
    │   │
    │   ├── models/                      # Schema data Firestore → LAU
    │   │   ├── category_model.dart      # Kategori (Individu/Kelompok/dll)
    │   │   ├── checklist_model.dart     # Sub-tugas
    │   │   ├── nontification_model.dart # ⚠️ Data notifikasi/reminder
    │   │   ├── task_model.dart          # Data tugas utama
    │   │   └── user_model.dart          # Profil mahasiswa
    │   │
    │   ├── services/                    # Logika Firebase/API → LAU & BIN
    │   │   ├── auth_service.dart            # Login/Register/Logout (.ac.id)  [BIN]
    │   │   ├── category_service.dart        # CRUD Categories                 [LAU]
    │   │   ├── checklist_service.dart       # CRUD Checklist/sub-tugas        [LAU]
    │   │   ├── task_service.dart            # CRUD Tasks                      [LAU]
    │   │   ├── user_service.dart            # CRUD/Read profil user           [LAU]
    │   │   ├── fcm_service.dart             # Push notification handler       [BIN]
    │   │   ├── local_nontification.dart     # ⚠️ Reminder H-3, H-2, H-1       [BIN]
    │   │   └── nontification_service.dart   # ⚠️ CRUD data notifikasi         [BIN]
    │   │
    │   ├── providers/                   # State management → LAU & BIN
    │   │   ├── auth_provider.dart           # Status login/user data          [BIN]
    │   │   ├── category_provider.dart       # List kategori global            [LAU]
    │   │   ├── nontification_provider.dart  # ⚠️ Badge count, unread list     [BIN]
    │   │   └── task_provider.dart           # List tasks, filter, search      [LAU]
    │   │
    │   └── features/                    # UI layar berdasarkan fitur
    │       ├── splash/                  # → ALY
    │       │   └── splash_screen.dart       # Layar pembuka + mascot Dino
    │       ├── auth/                    # → LAI
    │       │   ├── login_screen.dart        # Form login + validasi
    │       │   ├── register_screen.dart     # Form daftar + cek .ac.id
    │       │   └── widgets/
    │       ├── dashboard/               # → ALY
    │       │   ├── dashboard_screen.dart    # Beranda + statistik + filter
    │       │   └── widgets/                 # summary_card, filter_bar
    │       ├── task/                    # → ALY
    │       │   ├── add_task_screen.dart     # Form tambah tugas + Smart Alarm
    │       │   ├── edit_task_screen.dart    # Edit detail tugas
    │       │   ├── task_detail_screen.dart  # Detail + checklist + countdown
    │       │   └── widgets/
    │       │       ├── checklist_item.dart  # Widget sub-tugas
    │       │       └── task_form.dart       # Reusable form input tugas
    │       ├── history/                 # → LAI
    │       │   ├── history_screen.dart      # Riwayat selesai + grafik
    │       │   └── widgets/                 # productivity_chart, completed_task_card
    │       ├── nontification/           # ⚠️ → BIN (nama folder typo)
    │       │   └── notification_screen.dart # Daftar reminder deadline
    │       ├── notification/            # ⚠️ → BIN (duplikat, hanya berisi .gitkeep)
    │       └── profile/                 # → LAI
    │           ├── profile_screen.dart      # Info akun + statistik pribadi
    │           └── widgets/
    │               └── settings_tile.dart   # Toggle Dark Mode, Notifikasi
    │
    ├── test/                            # Quality assurance → DEL
    │   ├── unit/                        # auth_service_test, priority_calculator_test
    │   └── widget/                      # login_screen_test, task_card_test
    │
    ├── tools/                           # DevOps automation → DEL
    │   └── (check_lint.sh, build_apk.sh — akan dibuat)
    │
    └── docs/                            # Dokumentasi teknis → ALYA & DEL
        └── (api_reference.md, database_schema.md, CONTRIBUTING.md, weekly_report.md)
```

### 🔄 Perubahan dari Rencana Awal

| Rencana Awal                      | Kondisi Sekarang                                                                     | Keterangan                                 |
| --------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------ |
| `firestore_service.dart` (1 file) | Dipecah jadi `task_service`, `category_service`, `checklist_service`, `user_service` | Lebih modular, tetap milik **Laudya**      |
| —                                 | `nontification_service.dart` (baru)                                                  | Service data notifikasi, milik **Bintoro** |
| `custom_*.dart`                   | `costom_*.dart`                                                                      | Typo, perlu diperbaiki                     |
| `loading_indicator.dart`          | `loading_inicator.dart`                                                              | Typo, perlu diperbaiki                     |
| `notification*`                   | `nontification*`                                                                     | Typo di model, provider, service, folder   |
| `features/notification/`          | Ada 2 folder: `nontification/` & `notification/`                                     | Duplikat, harus disatukan                  |

---

## 🗂️ Kepemilikan Folder

| Folder                        | PIC              | Tanggung Jawab                                                                                                                                                           |
| ----------------------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `lib/app/`                    | Aliyah           | Rute navigasi & tema global sesuai desain Figma (warna Teal, tipografi, UI Kit)                                                                                          |
| `lib/config/`                 | Alya             | Feature flags & dokumentasi kebutuhan teknis sistem                                                                                                                      |
| `lib/core/constants/`         | Alya             | Penerjemahan desain Figma ke kode (warna, teks, ukuran)                                                                                                                  |
| `lib/core/utils/`             | Alya & Bintoro   | Alya: `email_validator`, `date_formatter` · Bintoro: `priority_calculator`                                                                                               |
| `lib/core/widgets/`           | Aliyah           | Widget reusable seluruh aplikasi                                                                                                                                         |
| `lib/models/`                 | Laudya           | Struktur data sesuai skema Firestore, lengkap dengan `fromFirestore()` & `toFirestore()`                                                                                 |
| `lib/services/`               | Laudya & Bintoro | Laudya: `task_service`, `category_service`, `checklist_service`, `user_service` · Bintoro: `auth_service`, `fcm_service`, `local_nontification`, `nontification_service` |
| `lib/providers/`              | Laudya & Bintoro | Laudya: `task_provider`, `category_provider` · Bintoro: `auth_provider`, `nontification_provider`                                                                        |
| `lib/features/splash/`        | Aliyah           | Layar pembuka + mascot Dino                                                                                                                                              |
| `lib/features/auth/`          | Laili            | Login & register dengan validasi                                                                                                                                         |
| `lib/features/dashboard/`     | Aliyah           | Beranda, statistik, filter                                                                                                                                               |
| `lib/features/task/`          | Aliyah           | Tambah, edit, dan detail tugas                                                                                                                                           |
| `lib/features/history/`       | Laili            | Riwayat tugas selesai & grafik produktivitas                                                                                                                             |
| `lib/features/nontification/` | Bintoro          | Daftar reminder deadline                                                                                                                                                 |
| `lib/features/profile/`       | Laili            | Info akun & pengaturan                                                                                                                                                   |
| `test/`                       | Delavanti        | Unit test & widget test, target coverage minimal **70%**                                                                                                                 |
| `tools/`                      | Delavanti        | Script lint check & build APK                                                                                                                                            |
| `docs/`                       | Alya & Delavanti | Dokumentasi teknis proyek                                                                                                                                                |

---

## 📊 Detail Tanggung Jawab per Anggota

### 1. Aliyah Tasya Ashifah (125) — Frontend Lead & UI Kit

| File/Folder                              | Deskripsi                                                                                  |
| ---------------------------------------- | ------------------------------------------------------------------------------------------ |
| `lib/app/routes/app_routes.dart`         | Konfigurasi navigasi antar halaman                                                         |
| `lib/app/theme/app_theme.dart`           | Tema global (warna Teal, font, UI Kit)                                                     |
| `lib/core/widgets/`                      | `costom_button`, `costom_textfield`, `task_card`, `priority_badge`, `loading_inicator`     |
| `lib/features/splash/splash_screen.dart` | Layar pembuka dengan mascot Dino                                                           |
| `lib/features/dashboard/`                | `dashboard_screen` + widgets (summary card, filter bar)                                    |
| `lib/features/task/`                     | `add_task_screen`, `edit_task_screen`, `task_detail_screen`, `task_form`, `checklist_item` |
| `main.dart` (bagian routing/tema)        | Menghubungkan `app_routes` & `app_theme` (koordinasi dengan Laudya)                        |

**🎯 Output:** UI Kit konsisten, widget reusable, layar inti sesuai Figma.

### 2. Laili Nurul Fadila (013) — Frontend & User Flow

| File/Folder             | Deskripsi                                                       |
| ----------------------- | --------------------------------------------------------------- |
| `lib/features/auth/`    | `login_screen`, `register_screen`, widgets form dengan validasi |
| `lib/features/history/` | `history_screen`, grafik produktivitas, completed task card     |
| `lib/features/profile/` | `profile_screen`, `settings_tile` (Dark Mode, Notifikasi)       |

**🎯 Output:** Flow autentikasi aman, halaman riwayat interaktif, form profil.

### 3. Laudya Aulia Putri (042) — Backend Lead & PM

| File/Folder                            | Deskripsi                                                                              |
| -------------------------------------- | -------------------------------------------------------------------------------------- |
| `lib/models/`                          | `user_model`, `task_model`, `category_model`, `checklist_model`, `nontification_model` |
| `lib/services/task_service.dart`       | CRUD Tasks                                                                             |
| `lib/services/category_service.dart`   | CRUD Categories                                                                        |
| `lib/services/checklist_service.dart`  | CRUD Checklist/sub-tugas                                                               |
| `lib/services/user_service.dart`       | CRUD/Read data User                                                                    |
| `lib/providers/task_provider.dart`     | State management list tasks, filter, search                                            |
| `lib/providers/category_provider.dart` | State management kategori global                                                       |
| `main.dart`, `firebase_options.dart`   | Setup Firebase & MultiProvider                                                         |

**🎯 Output:** Integrasi Firestore mulus, struktur data NoSQL, state management tugas.

### 4. Bintoro Amansyah (004) — Backend Logic

| File/Folder                                 | Deskripsi                                      |
| ------------------------------------------- | ---------------------------------------------- |
| `lib/services/auth_service.dart`            | Login, Register, Logout dengan validasi .ac.id |
| `lib/services/fcm_service.dart`             | Firebase Cloud Messaging handler               |
| `lib/services/local_nontification.dart`     | Reminder H-3, H-2, H-1                         |
| `lib/services/nontification_service.dart`   | CRUD data notifikasi di Firestore              |
| `lib/providers/auth_provider.dart`          | State management auth & user data              |
| `lib/providers/nontification_provider.dart` | Badge count & unread list                      |
| `lib/core/utils/priority_calculator.dart`   | Algoritma perhitungan skor prioritas           |
| `lib/features/nontification/`               | Layar daftar reminder deadline                 |

**🎯 Output:** Sistem Auth & Notifikasi aktif, algoritma prioritas akurat.

### 5. Alya Ramadhani (144) — System Analyst & Config

| File/Folder                           | Deskripsi                                                           |
| ------------------------------------- | ------------------------------------------------------------------- |
| `lib/config/`                         | `feature_flags.dart` & `requirements.md`                            |
| `lib/core/constants/`                 | `app_colors`, `app_strings`, `app_sizes` (terjemahan Figma ke kode) |
| `lib/core/utils/email_validator.dart` | Validasi domain .ac.id                                              |
| `lib/core/utils/date_formatter.dart`  | Format deadline & countdown                                         |
| `docs/`                               | `api_reference`, `database_schema`, `CONTRIBUTING`, `weekly_report` |

**🎯 Output:** Constants terstruktur, validator & formatter fungsional, dokumentasi lengkap.

### 6. Delavanti Gogumo (177) — QA & DevOps

| File/Folder            | Deskripsi                                                        |
| ---------------------- | ---------------------------------------------------------------- |
| `test/unit/`           | Unit test untuk auth service & priority calculator               |
| `test/widget/`         | Widget test untuk login screen & task card                       |
| `tools/`               | Script automation (`check_lint.sh`, `build_apk.sh`)              |
| `docs/CONTRIBUTING.md` | Panduan kontribusi tim (kolaborasi dengan Alya)                  |
| Git management         | Review PR, proteksi branch `main`/`develop`, perapihan nama typo |

**🎯 Output:** Unit & widget tests, script CI/CD dasar, build APK final, Git management.

---

## 🌿 Branch yang Harus Dibuat per Anggota

Format: `feature/[nama-fitur]-[nama]` — dibuat dari branch **`develop`**, di-merge kembali ke `develop` lewat Pull Request.

### 🔧 Branch Awal (dibuat Delavanti)

| Branch                            | Dari      | Fungsi                                                                                              |
| --------------------------------- | --------- | --------------------------------------------------------------------------------------------------- |
| `main`                            | —         | Production ready                                                                                    |
| `develop`                         | `main`    | Integration branch                                                                                  |
| `chore/fix-typo-naming-delavanti` | `develop` | Perapihan nama typo & folder duplikat (**dikerjakan pertama**, sebelum yang lain mulai import file) |

### 👩‍💻 Aliyah — Frontend Lead & UI Kit

| Branch                        | Cakupan                                                    | Minggu |
| ----------------------------- | ---------------------------------------------------------- | :----: |
| `feature/theme-routes-aliyah` | `app/theme/app_theme.dart`, `app/routes/app_routes.dart`   |   2    |
| `feature/core-widgets-aliyah` | `core/widgets/*`                                           |   5    |
| `feature/splash-aliyah`       | `features/splash/`                                         |   4    |
| `feature/dashboard-aliyah`    | `features/dashboard/` (+ widgets)                          |   4    |
| `feature/task-ui-aliyah`      | `features/task/` (add, edit, detail, form, checklist item) |   5    |

### 👩‍💻 Laili — Frontend & User Flow

| Branch                  | Cakupan                                             | Minggu |
| ----------------------- | --------------------------------------------------- | :----: |
| `feature/auth-ui-laili` | `features/auth/` (login, register, widgets)         |   3    |
| `feature/history-laili` | `features/history/` (screen, chart, completed card) |   6    |
| `feature/profile-laili` | `features/profile/` (screen, settings tile)         |   6    |

### 👩‍💻 Laudya — Backend Lead & PM

| Branch                              | Cakupan                                                                          | Minggu |
| ----------------------------------- | -------------------------------------------------------------------------------- | :----: |
| `feature/models-laudya`             | `models/*`                                                                       |   2    |
| `feature/firestore-services-laudya` | `services/task_service`, `category_service`, `checklist_service`, `user_service` |  3–4   |
| `feature/task-provider-laudya`      | `providers/task_provider.dart`                                                   |   4    |
| `feature/category-provider-laudya`  | `providers/category_provider.dart`                                               |   4    |
| `feature/main-setup-laudya`         | `main.dart`, `firebase_options.dart`, MultiProvider                              |   1    |

### 👨‍💻 Bintoro — Backend Logic

| Branch                                 | Cakupan                                                                | Minggu |
| -------------------------------------- | ---------------------------------------------------------------------- | :----: |
| `feature/auth-service-bintoro`         | `services/auth_service.dart` + `providers/auth_provider.dart`          |  3–4   |
| `feature/priority-calculator-bintoro`  | `core/utils/priority_calculator.dart`                                  |   4    |
| `feature/notification-service-bintoro` | `services/fcm_service`, `local_nontification`, `nontification_service` |   7    |
| `feature/notification-ui-bintoro`      | `providers/nontification_provider.dart` + `features/nontification/`    |   7    |

### 👩‍💻 Alya — System Analyst & Config

| Branch                   | Cakupan                                                                     | Minggu |
| ------------------------ | --------------------------------------------------------------------------- | :----: |
| `feature/constants-alya` | `core/constants/*` (colors, strings, sizes)                                 |   2    |
| `feature/utils-alya`     | `core/utils/email_validator.dart`, `date_formatter.dart`                    |  2–3   |
| `feature/config-alya`    | `config/feature_flags.dart`, `config/requirements.md`                       |  1–2   |
| `docs/api-schema-alya`   | `docs/api_reference.md`, `docs/database_schema.md`, `docs/weekly_report.md` |  2–9   |

### 👩‍💻 Delavanti — QA & DevOps

| Branch                            | Cakupan                                     | Minggu |
| --------------------------------- | ------------------------------------------- | :----: |
| `chore/fix-typo-naming-delavanti` | Perapihan nama (lihat Branch Awal)          |   1    |
| `feature/unit-test-delavanti`     | `test/unit/`                                |   8    |
| `feature/widget-test-delavanti`   | `test/widget/`                              |   8    |
| `feature/tools-delavanti`         | `tools/check_lint.sh`, `tools/build_apk.sh` |   8    |
| `docs/contributing-delavanti`     | `docs/CONTRIBUTING.md`                      |  1–2   |
| `release/v1.0.0-delavanti`        | Build APK final & rilis                     |   10   |

---

## 📖 Panduan Membuat Branch

Panduan ini dipakai **semua anggota**. Contoh di bawah memakai branch `feature/splash-aliyah`; ganti dengan nama branch milik masing-masing sesuai tabel di atas.

### Aturan Penamaan Branch

| Aturan                                              | Benar ✅                                       | Salah ❌                                         |
| --------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------ |
| Huruf kecil semua                                   | `feature/splash-aliyah`                        | `Feature/Splash-Aliyah`                          |
| Pakai tanda hubung `-`, tanpa spasi/underscore      | `feature/auth-ui-laili`                        | `feature/auth ui laili`, `feature/auth_ui_laili` |
| Diakhiri nama anggota                               | `feature/models-laudya`                        | `feature/models`                                 |
| Ejaan benar (`notification`, bukan `nontification`) | `feature/notification-ui-bintoro`              | `feature/nontification-ui-bintoro`               |
| Awalan sesuai jenis pekerjaan                       | `docs/api-schema-alya`, `chore/...`, `fix/...` | `alya-docs`                                      |

### Langkah 1 — Siapkan Repository (sekali saja)

Jika belum punya project di laptop:

```bash
git clone <url-repository-github>
cd REMINDER-APPLICATION-PROJECT
```

Cek identitas Git agar commit tercatat atas nama masing-masing di GitHub:

```bash
git config user.name "Nama Kamu"
git config user.email "email-github-kamu@example.com"
```

### Langkah 2 — Pindah ke `develop` & Ambil Update Terbaru

Setiap branch baru **wajib** dibuat dari `develop` yang sudah terbaru, bukan dari `main` atau dari branch fitur lain.

```bash
git checkout develop
git pull origin develop
```

> Jika muncul `error: pathspec 'develop' did not match`, jalankan `git fetch origin` dulu, lalu ulangi perintah di atas.

### Langkah 3 — Buat Branch Baru

```bash
git checkout -b feature/splash-aliyah
```

`-b` artinya "buat branch baru sekaligus pindah ke branch itu". Pastikan posisinya benar:

```bash
git branch
# * feature/splash-aliyah   <- tanda bintang = branch aktif
#   develop
#   main
```

> Alternatif versi baru Git: `git switch -c feature/splash-aliyah`.

### Langkah 4 — Kerjakan Tugas & Commit

Kerjakan **hanya file milik PIC kamu** (lihat tabel [Kepemilikan Folder](#️-kepemilikan-folder)). Commit sering dengan pesan sesuai [konvensi](#4-commit-message-convention).

```bash
git status                                  # lihat file yang berubah
git add lib/features/splash/splash_screen.dart
git commit -m "feat: tambah splash screen dengan mascot Dino"
```

Tips: hindari `git add .` jika ada file di luar tugasmu yang ikut berubah; tambahkan file satu per satu agar commit rapi.

### Langkah 5 — Push Branch ke GitHub

Push pertama kali pakai `-u` agar branch lokal terhubung dengan branch di GitHub:

```bash
git push -u origin feature/splash-aliyah
```

Push berikutnya cukup:

```bash
git push
```

### Langkah 6 — Buat Pull Request (PR)

1. Buka repository di GitHub, klik tombol **Compare & pull request** (atau tab **Pull requests → New pull request**).
2. Atur **base: `develop`** ← **compare: `feature/splash-aliyah`**. (Jangan pilih `main`.)
3. Isi judul sesuai konvensi commit, misalnya `feat: splash screen`, dan tulis deskripsi singkat: apa yang dikerjakan dan cara mengujinya.
4. Pilih **Reviewers** minimal 1 anggota lain.
5. Klik **Create pull request**.
6. Setelah di-approve dan di-merge, klik **Delete branch** di GitHub.

### Langkah 7 — Bersihkan & Sinkronkan Setelah Merge

```bash
git checkout develop
git pull origin develop
git branch -d feature/splash-aliyah          # hapus branch lokal
```

Lalu mulai tugas berikutnya dengan mengulang dari **Langkah 3** (branch baru dari `develop` terbaru).

### Saat Branch Tertinggal dari `develop`

Jika sedang mengerjakan fitur dan `develop` sudah berubah (misalnya ada update dari anggota lain), ambil perubahannya ke branch kamu:

```bash
git checkout feature/splash-aliyah
git fetch origin
git merge origin/develop
```

Jika muncul **conflict**:

1. Buka file yang ditandai (`<<<<<<<`, `=======`, `>>>>>>>`) di VS Code.
2. Pilih **Accept Current / Incoming / Both** sesuai kebutuhan, lalu hapus semua penanda conflict.
3. Selesaikan dengan:

```bash
git add <file-yang-conflict>
git commit -m "merge: sinkron dengan develop"
git push
```

> Jika ragu saat menyelesaikan conflict, tanyakan ke PIC file tersebut atau ke Delavanti (Git management) sebelum memaksa push.

### Khusus Delavanti — Membuat `develop` & Proteksi Branch (sekali di awal)

```bash
git checkout main
git pull origin main
git checkout -b develop
git push -u origin develop
```

Lalu di GitHub: **Settings → Branches → Add branch ruleset** untuk `main` dan `develop`:

- ✅ Require a pull request before merging
- ✅ Require at least 1 approval
- ✅ Block force pushes

Setelah `develop` ada, Delavanti membuat dan menyelesaikan `chore/fix-typo-naming-delavanti`, lalu memberi tahu tim agar semua `git pull origin develop` **sebelum** membuat branch masing-masing.

### Ringkasan Perintah

| Tujuan                                | Perintah                               |
| ------------------------------------- | -------------------------------------- |
| Lihat semua branch lokal              | `git branch`                           |
| Lihat semua branch termasuk di GitHub | `git branch -a`                        |
| Pindah branch                         | `git checkout nama-branch`             |
| Buat & pindah ke branch baru          | `git checkout -b nama-branch`          |
| Ambil update terbaru dari GitHub      | `git pull origin develop`              |
| Push pertama kali                     | `git push -u origin nama-branch`       |
| Push selanjutnya                      | `git push`                             |
| Hapus branch lokal                    | `git branch -d nama-branch`            |
| Hapus branch di GitHub                | `git push origin --delete nama-branch` |
| Salah nama branch (rename)            | `git branch -m nama-baru`              |

### Kesalahan Umum

| Masalah                                   | Penyebab                                                      | Solusi                                                                                                                                            |
| ----------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Commit masuk ke `develop`/`main`          | Lupa pindah branch sebelum mengerjakan                        | Segera beri tahu tim; jangan push. Buat branch baru dari posisi sekarang (`git checkout -b feature/...`) lalu reset `develop` ke `origin/develop` |
| PR berisi banyak file milik orang lain    | Branch dibuat dari branch fitur lain atau dari `develop` lama | Buat ulang branch dari `develop` terbaru lalu `cherry-pick` commit kamu                                                                           |
| `rejected ... non-fast-forward` saat push | Branch di GitHub lebih baru dari lokal                        | `git pull origin nama-branch` lalu push lagi (jangan `--force`)                                                                                   |
| Import error setelah pull                 | Ada file di-rename (perapihan typo)                           | Perbaiki path import sesuai nama baru di `develop`                                                                                                |

---

## ⚠️ Catatan Penting

### 1. Perapihan Nama (Typo & Folder Duplikat)

Beberapa nama file/folder di repository mengandung typo. Sebaiknya **diperbaiki sekarang** (dikerjakan Delavanti di branch `chore/fix-typo-naming-delavanti`, lalu semua anggota `git pull` dari `develop`) sebelum banyak file saling meng-import.

| Sekarang                                             | Seharusnya                            |
| ---------------------------------------------------- | ------------------------------------- |
| `core/widgets/costom_button.dart`                    | `custom_button.dart`                  |
| `core/widgets/costom_textfield.dart`                 | `custom_textfield.dart`               |
| `core/widgets/loading_inicator.dart`                 | `loading_indicator.dart`              |
| `models/nontification_model.dart`                    | `notification_model.dart`             |
| `providers/nontification_provider.dart`              | `notification_provider.dart`          |
| `services/local_nontification.dart`                  | `local_notification.dart`             |
| `services/nontification_service.dart`                | `notification_service.dart`           |
| `features/nontification/` + `features/notification/` | Satukan jadi `features/notification/` |

> 💡 Gunakan `git mv` (bukan rename manual) agar riwayat file tetap terlacak di GitHub. Setelah rename, setiap anggota yang sudah meng-import file tersebut perlu menyesuaikan path import-nya.

### 2. Branching Strategy

| Branch                        | Fungsi                                                          |
| ----------------------------- | --------------------------------------------------------------- |
| `main`                        | Production ready, hanya menerima merge dari `develop`/`release` |
| `develop`                     | Integration branch, tempat semua fitur digabung                 |
| `feature/[nama-fitur]-[nama]` | Development fitur per anggota                                   |
| `docs/[topik]-[nama]`         | Perubahan dokumentasi                                           |
| `chore/[topik]-[nama]`        | Perapihan, konfigurasi, rename                                  |
| `fix/[bug]-[nama]`            | Perbaikan bug                                                   |
| `release/vX.Y.Z-[nama]`       | Persiapan rilis                                                 |

### 3. Aturan Branch & Pull Request

- Dilarang commit langsung ke `main` dan `develop`.
- Satu branch = satu fitur/folder kecil; hindari branch yang terlalu besar.
- Selalu `git pull origin develop` sebelum mulai bekerja dan sebelum membuat PR.
- Setiap PR minimal di-review **1 anggota lain** (Laudya sebagai PM & Delavanti sebagai QA berhak merge ke `develop`).
- Jalankan lint/test sebelum push (`tools/check_lint.sh` jika sudah tersedia).
- Hapus branch setelah PR berhasil di-merge.

### 4. Commit Message Convention

| Prefix      | Kegunaan                       |
| ----------- | ------------------------------ |
| `feat:`     | Menambah fitur baru            |
| `fix:`      | Memperbaiki bug                |
| `docs:`     | Update dokumentasi             |
| `style:`    | Perbaikan format kode          |
| `test:`     | Menambah/memperbaiki test      |
| `refactor:` | Refactoring kode               |
| `chore:`    | Perapihan, rename, konfigurasi |

### 5. Aturan Kontribusi

Setiap anggota wajib:

- [x] Memiliki kontribusi pada repository
- [x] Memahami struktur project
- [x] Memahami fitur yang dikerjakan
- [x] Mampu menjelaskan kode yang dibuat
- [x] Mampu melakukan debugging sederhana
- [x] Mampu menjelaskan hubungan antara frontend, API, dan database

---

## 🎯 Timeline Implementasi

| Minggu | Fokus                                                                                                                           | PIC Utama                        |
| :----: | ------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
|   1    | Setup project, struktur folder, `.gitkeep`, perapihan nama typo, `main.dart` & Firebase setup                                   | Semua anggota, Delavanti, Laudya |
|   2    | `core/constants/`, `config/`, `app/theme/`, `models/`, `core/utils/` (validator & formatter)                                    | Alya, Aliyah, Laudya             |
|   3    | `services/auth_service.dart`, `features/auth/`, `services/*_service.dart` (Firestore)                                           | Bintoro, Laili, Laudya           |
|   4    | `providers/`, `core/utils/priority_calculator.dart`, `features/splash/`, `features/dashboard/`                                  | Laudya, Bintoro, Aliyah          |
|   5    | `features/task/`, `core/widgets/`                                                                                               | Aliyah                           |
|   6    | `features/history/`, `features/profile/`                                                                                        | Laili                            |
|   7    | `services/fcm_service.dart`, `services/local_notification.dart`, `services/notification_service.dart`, `features/notification/` | Bintoro                          |
|   8    | `test/`, `tools/`, integrasi & testing                                                                                          | Delavanti, Semua anggota         |
|   9    | Bug fixing, UI polish, dokumentasi                                                                                              | Semua anggota                    |
|   10   | Build APK, final testing, deployment                                                                                            | Delavanti, Laudya                |
