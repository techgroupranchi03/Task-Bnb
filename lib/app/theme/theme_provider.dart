import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/shared_prefs_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadSavedTheme();
  }

  static const _themeKey = 'app_theme_mode';

  void _loadSavedTheme() {
    final saved = SharedPrefsService.instance.getString(_themeKey);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  void toggle() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      SharedPrefsService.instance.setString(_themeKey, 'light');
    } else {
      state = ThemeMode.dark;
      SharedPrefsService.instance.setString(_themeKey, 'dark');
    }
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
