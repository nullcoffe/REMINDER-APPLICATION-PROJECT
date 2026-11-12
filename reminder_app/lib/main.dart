import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'features/profile/theme_settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final themeName = prefs.getString('theme_mode') ?? 'light';
  final initialThemeMode = ThemeMode.values.firstWhere(
    (m) => m.name == themeName,
    orElse: () => ThemeMode.light,
  );

  runApp(TaskZillaApp(initialThemeMode: initialThemeMode));
}

class TaskZillaApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const TaskZillaApp({super.key, required this.initialThemeMode});

  @override
  State<TaskZillaApp> createState() => _TaskZillaAppState();
}

class _TaskZillaAppState extends State<TaskZillaApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskZilla',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.themeSettings) {
          return MaterialPageRoute(
            builder: (_) => ThemeSettingsScreen(
              currentThemeMode: _themeMode,
              onThemeChanged: setThemeMode,
            ),
          );
        }
        return AppRoutes.generateRoute(settings);
      },
    );
  }
}
