import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Proveedor de SharedPreferences (debe inicializarse en main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _themeKey = 'theme_mode';

  ThemeModeNotifier(this._prefs) : super(_loadTheme(_prefs));

  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final themeStr = prefs.getString(_themeKey);
    if (themeStr == 'dark') return ThemeMode.dark;
    if (themeStr == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.light || state == ThemeMode.system) {
      state = ThemeMode.dark;
      _prefs.setString(_themeKey, 'dark');
    } else {
      state = ThemeMode.light;
      _prefs.setString(_themeKey, 'light');
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _prefs.setString(_themeKey, mode.toString().split('.').last);
  }
}

final themeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});
