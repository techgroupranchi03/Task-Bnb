import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefsService {
  SharedPrefsService._();
  static final SharedPrefsService instance = SharedPrefsService._();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Theme ──────────────────────────────────────────────
  Future<void> setTheme(String theme) =>
      _prefs.setString(AppConstants.themeKey, theme);

  String getTheme() =>
      _prefs.getString(AppConstants.themeKey) ?? 'light';

  // ── Onboarding ─────────────────────────────────────────
  Future<void> setOnboardingDone(bool done) =>
      _prefs.setBool(AppConstants.onboardingDoneKey, done);

  bool isOnboardingDone() =>
      _prefs.getBool(AppConstants.onboardingDoneKey) ?? false;

  // ── Locale ─────────────────────────────────────────────
  Future<void> setLocale(String locale) =>
      _prefs.setString(AppConstants.localeKey, locale);

  String getLocale() =>
      _prefs.getString(AppConstants.localeKey) ?? 'en';

  // ── Generic ────────────────────────────────────────────
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clearAll() => _prefs.clear();
}
