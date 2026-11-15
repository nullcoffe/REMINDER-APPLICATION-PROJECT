import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_sizes.dart';

class ThemeSettingsScreen extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeSettingsScreen({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late ThemeMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.currentThemeMode;
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
    widget.onThemeChanged(mode);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Tema Aplikasi'),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Column(
          children: [
            _themeOption(
              mode: ThemeMode.light,
              icon: Icons.light_mode_outlined,
              title: 'Terang',
              subtitle: 'Tampilan dengan latar belakang terang',
            ),
            const SizedBox(height: 12),
            _themeOption(
              mode: ThemeMode.dark,
              icon: Icons.dark_mode_outlined,
              title: 'Gelap',
              subtitle: 'Tampilan dengan latar belakang gelap',
            ),
            const SizedBox(height: 12),
            _themeOption(
              mode: ThemeMode.system,
              icon: Icons.settings_suggest_outlined,
              title: 'Ikuti Sistem',
              subtitle: 'Sesuaikan dengan pengaturan perangkat',
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeOption({
    required ThemeMode mode,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = _selectedMode == mode;

    return Card(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? cs.primary : cs.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cs.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: cs.primary)
            : null,
        onTap: () {
          setState(() => _selectedMode = mode);
          _saveTheme(mode);
        },
      ),
    );
  }
}