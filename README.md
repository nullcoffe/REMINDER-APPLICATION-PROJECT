lib/
├── main.dart                      # Entry point (Firebase + MultiProvider)
├── firebase_options.dart          # Auto-generated Firebase Config
│
├── app/                           # Konfigurasi Global Aplikasi
│   ├── routes/
│   │   ── app_routes.dart        # [ALIYAH] Navigasi antar halaman
│   └── theme/
│       └── app_theme.dart         # [ALIYAH] Tema warna Teal, Font, UI Kit
│
├── config/                        # [ALYA] System Analyst Assets & Rules
│   ├── feature_flags.dart         # Toggle fitur MVP vs Future
│   └── requirements.md            # Catatan analisis kebutuhan teknis
│
── core/                          # Komponen Dasar Reusable
│   ├── constants/                 # [ALYA] Penerjemahan Figma ke Kode
│   │   ├── app_colors.dart        # Kode warna hex dari Figma
│   │   ├── app_strings.dart       # Teks statis aplikasi
│   │   └── app_sizes.dart         # Padding/Margin standar
│   ├── utils/                     # [ALYA/BINTORO] Logika Helper
│   │   ├── email_validator.dart   # Validasi domain .ac.id [ALYA]
│   │   ├── date_formatter.dart    # Format deadline & countdown [ALYA]
│   │   └── priority_calculator.dart # Logika skor prioritas otomatis [BINTORO]
│   └── widgets/                   # [ALIYAH] Widget Reusable
│       ├── custom_button.dart     # Tombol standar TaskZilla
│       ├── custom_textfield.dart  # Input form dengan validasi
│       ├── task_card.dart         # Kartu tugas (Dashboard/Riwayat)
│       ├── priority_badge.dart    # Label Urgent/High/Medium/Low
│       └── loading_indicator.dart # Animasi loading global
│
── models/                        # [LAUDYA] Schema Data Firestore
│   ├── user_model.dart            # Profil mahasiswa
│   ├── task_model.dart            # Data tugas utama
│   ├── category_model.dart        # Kategori (Individu/Kelompok/dll)
│   ├── checklist_model.dart       # Sub-tugas
│   └── notification_model.dart    # Data notifikasi/reminder
│
├── services/                      # [LAUDYA/BINTORO] Logika Firebase/API
│   ├── auth_service.dart          # Login/Register/Logout (.ac.id check) [BINTORO]
│   ├── firestore_service.dart     # CRUD Tasks, Categories, Users [LAUDYA]
│   ├── fcm_service.dart           # Push Notification handler [BINTORO]
│   └── local_notification.dart    # Reminder H-3, H-2, H-1 [BINTORO]
│
├── providers/                     # State Management (Provider)
│   ├── auth_provider.dart         # [BINTORO] Status login/user data
│   ├── task_provider.dart         # [LAUDYA] List tasks, filter, search
│   ├── category_provider.dart     # [LAUDYA] List kategori global
│   └── notification_provider.dart # [BINTORO] Badge count, unread list
│
└── features/                      # UI Layar Berdasarkan Fitur
    ├── splash/
    │   └── splash_screen.dart     # [ALIYAH] Layar pembuka + Mascot Dino
    ├── auth/
    │   ├── login_screen.dart      # [LAILI] Form login + validasi
    │   ├── register_screen.dart   # [LAILI] Form daftar + cek .ac.id
    │   └── widgets/
    │       └── auth_form_helper.dart
    ├── dashboard/
    │   ├── dashboard_screen.dart  # [ALIYAH] Beranda + Statistik + Filter
    │   └── widgets/
    │       ├── summary_card.dart  # Ringkasan To Do/In Progress
    │       └── filter_bar.dart    # Filter Kategori/Difficulty
    ├── task/
    │   ├── add_task_screen.dart   # [ALIYAH] Form tambah tugas + Smart Alarm
    │   ├── edit_task_screen.dart  # [ALIYAH] Edit detail tugas
    │   ├── task_detail_screen.dart# [ALIYAH] Detail + Checklist + Countdown
    │   └── widgets/
    │       ├── task_form.dart     # Reusable form input tugas
    │       └── checklist_item.dart # Widget sub-tugas
    ├── history/
    │   ├── history_screen.dart    # [LAILI] Riwayat selesai + Grafik
    │   └── widgets/
    │       ├── productivity_chart.dart # Grafik batang mingguan
    │       └── completed_task_card.dart
    ├── notification/
    │   └── notification_screen.dart # [BINTORO] Daftar reminder deadline
    └── profile/
        ├── profile_screen.dart    # [LAILI] Info akun + Statistik pribadi
        └── widgets/
            └── settings_tile.dart # Toggle Dark Mode, Notifikasi

test/                              # [DELAVANTI] Quality Assurance
── unit/
│   ├── auth_service_test.dart     # Test validasi email & password
│   ── priority_calculator_test.dart # Test logika skor prioritas
└── widget/
    ├── login_screen_test.dart     # Test interaksi form login
    ── task_card_test.dart        # Test rendering kartu tugas

tools/                             # [DELAVANTI] DevOps Automation
├── check_lint.sh                  # Script cek kualitas kode sebelum commit
└── build_apk.sh                   # Script build APK release

docs/                              # [ALYA + DELAVANTI] Dokumentasi Teknis
├── api_reference.md               # Referensi endpoint Firestore
├── database_schema.md             # Visualisasi relasi collection
── CONTRIBUTING.md                # Panduan kontribusi tim
└── weekly_report.md               # Laporan progres mingguan
