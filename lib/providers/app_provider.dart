import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  int _completedLessons = 0;
  int _totalLessons = 0;
  double _quizAverage = 0.0;

  ThemeMode get themeMode => _themeMode;
  int get completedLessons => _completedLessons;
  int get totalLessons => _totalLessons;
  double get quizAverage => _quizAverage;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
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
