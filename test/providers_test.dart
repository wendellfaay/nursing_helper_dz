import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nursing_helper_dz/providers/app_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('AppProvider', () {
    test('initial state is light mode', () {
      final provider = AppProvider();
      expect(provider.isDarkMode, false);
      expect(provider.themeMode.name, 'light');
    });

    test('toggleTheme switches between light and dark', () {
      final provider = AppProvider();
      provider.toggleTheme();
      expect(provider.isDarkMode, true);
      provider.toggleTheme();
      expect(provider.isDarkMode, false);
    });

    test('updateStats updates all fields', () {
      final provider = AppProvider();
      provider.updateStats(completedLessons: 5, totalLessons: 10, quizAverage: 75.0);
      expect(provider.completedLessons, 5);
      expect(provider.totalLessons, 10);
      expect(provider.quizAverage, 75.0);
    });

    test('updateStats resets values', () {
      final provider = AppProvider();
      provider.updateStats(completedLessons: 5, totalLessons: 10, quizAverage: 75.0);
      provider.updateStats(completedLessons: 0, totalLessons: 0, quizAverage: 0.0);
      expect(provider.completedLessons, 0);
      expect(provider.totalLessons, 0);
      expect(provider.quizAverage, 0.0);
    });
  });
}
