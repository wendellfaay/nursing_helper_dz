import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  static const String _themeModeKey = 'themeMode';
  static const String _localeKey = 'languageCode';

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');
  int _completedLessons = 0;
  int _totalLessons = 0;
  double _quizAverage = 0.0;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  int get completedLessons => _completedLessons;
  int get totalLessons => _totalLessons;
  double get quizAverage => _quizAverage;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final themeString = prefs.getString(_themeModeKey);
    _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;

    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }

    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, isDarkMode ? 'dark' : 'light');
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _locale.languageCode);
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    _saveThemeMode();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _saveThemeMode();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
    _saveLocale();
  }

  void updateStats({
    required int completedLessons,
    required int totalLessons,
    required double quizAverage,
  }) {
    _completedLessons = completedLessons;
    _totalLessons = totalLessons;
    _quizAverage = quizAverage;
    notifyListeners();
  }
}
