import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/lesson.dart';
import '../models/glossary_term.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../models/user_progress.dart';
import '../models/year.dart';
import '../models/semester.dart';
import '../models/module.dart';
import '../models/favorite.dart';
import '../models/achievement.dart';

class DatabaseProvider extends ChangeNotifier {
  bool _initialized = false;
  int _completedLessons = 0;
  int _totalLessons = 0;
  double _quizAverage = 0.0;

  bool get initialized => _initialized;
  int get completedLessons => _completedLessons;
  int get totalLessons => _totalLessons;
  double get quizAverage => _quizAverage;

  Future<void> initialize() async {
    try {
      await DatabaseHelper.database;
      await refreshStats();
    } catch (_) {
      _initialized = false;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> refreshStats() async {
    _completedLessons = await DatabaseHelper.getCompletedLessonsCount();
    _totalLessons = await DatabaseHelper.getTotalLessonsCount();
    _quizAverage = await DatabaseHelper.getOverallQuizAverage();
    notifyListeners();
  }

  Future<List<Year>> getYears() => DatabaseHelper.getYears();
  Future<List<Semester>> getSemesters(int yearId) => DatabaseHelper.getSemesters(yearId);
  Future<List<Module>> getModules(int semesterId) => DatabaseHelper.getModules(semesterId);
  Future<List<Lesson>> getLessonsByModule(int moduleId) => DatabaseHelper.getLessonsByModule(moduleId);
  Future<Lesson?> getLesson(int id) => DatabaseHelper.getLesson(id);
  Future<List<Lesson>> getLessons({String? category}) => DatabaseHelper.getLessons(category: category);
  Future<List<Lesson>> searchLessons(String query) => DatabaseHelper.searchLessons(query);

  Future<List<GlossaryTerm>> getGlossaryTerms({String? category}) => DatabaseHelper.getGlossaryTerms(category: category);
  Future<List<GlossaryTerm>> searchGlossary(String query) => DatabaseHelper.searchGlossary(query);

  Future<List<QuizQuestion>> getQuizQuestions({String? topic}) => DatabaseHelper.getQuizQuestions(topic: topic);
  Future<List<QuizQuestion>> getRandomQuestions({String? topic, int limit = 10}) => DatabaseHelper.getRandomQuestions(topic: topic, limit: limit);

  Future<List<UserProgress>> getUserProgress() => DatabaseHelper.getUserProgress();
  Future<List<QuizResult>> getQuizResults() => DatabaseHelper.getQuizResults();

  Future<void> markLessonCompleted(int id, String category) async {
    await DatabaseHelper.markLessonCompleted(id);
    await DatabaseHelper.updateUserProgress(
      category,
      await DatabaseHelper.getCompletedLessonsCount(),
      await DatabaseHelper.getTotalLessonsCount(),
    );
    await refreshStats();
  }

  Future<void> saveQuizResult(QuizResult result) async {
    await DatabaseHelper.saveQuizResult(result);
    await refreshStats();
  }

  // Favorites
  Future<void> addFavorite(int contentId, String contentType, String contentTitle) =>
      DatabaseHelper.addFavorite(contentId, contentType, contentTitle);

  Future<void> removeFavorite(int contentId, String contentType) =>
      DatabaseHelper.removeFavorite(contentId, contentType);

  Future<List<Favorite>> getFavorites() => DatabaseHelper.getFavorites();

  Future<bool> isFavorite(int contentId, String contentType) =>
      DatabaseHelper.isFavorite(contentId, contentType);

  // Achievements
  Future<void> initializeAchievements() => DatabaseHelper.initializeAchievements();

  Future<void> unlockAchievement(int id) => DatabaseHelper.unlockAchievement(id);

  Future<List<Achievement>> getAchievements() => DatabaseHelper.getAchievements();

  Future<int> getUnlockedAchievementsCount() => DatabaseHelper.getUnlockedAchievementsCount();
}

