import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/lesson.dart';
import '../../models/glossary_term.dart';
import '../../models/quiz_question.dart';
import '../../models/quiz_result.dart';
import '../../models/user_progress.dart';
import '../../models/year.dart';
import '../../models/semester.dart';
import '../../models/module.dart';
import '../constants/constants.dart';
import 'seed_data.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE years (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nameAr TEXT NOT NULL,
        nameFr TEXT NOT NULL,
        orderIndex INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE semesters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        yearId INTEGER NOT NULL,
        name TEXT NOT NULL,
        nameAr TEXT NOT NULL,
        orderIndex INTEGER NOT NULL,
        FOREIGN KEY (yearId) REFERENCES years(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE modules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        semesterId INTEGER NOT NULL,
        name TEXT NOT NULL,
        nameAr TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (semesterId) REFERENCES semesters(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        moduleId INTEGER NOT NULL,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        academicYear TEXT NOT NULL,
        content TEXT NOT NULL,
        summary TEXT NOT NULL,
        keyPoints TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        FOREIGN KEY (moduleId) REFERENCES modules(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE glossary_terms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        termAr TEXT NOT NULL,
        termFr TEXT NOT NULL,
        definition TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE quiz_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        correctIndex INTEGER NOT NULL,
        topic TEXT NOT NULL,
        explanation TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic TEXT NOT NULL,
        totalQuestions INTEGER NOT NULL,
        correctAnswers INTEGER NOT NULL,
        percentage REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL UNIQUE,
        completedLessons INTEGER DEFAULT 0,
        totalLessons INTEGER DEFAULT 0,
        quizAverage REAL DEFAULT 0.0
      )
    ''');
    await SeedData.insertSeedData(db);
  }

  static Future<List<Year>> getYears() async {
    final db = await database;
    final maps = await db.query('years', orderBy: 'orderIndex ASC');
    return maps.map((m) => Year.fromMap(m)).toList();
  }

  static Future<List<Semester>> getSemesters(int yearId) async {
    final db = await database;
    final maps = await db.query('semesters', where: 'yearId = ?', whereArgs: [yearId], orderBy: 'orderIndex ASC');
    return maps.map((m) => Semester.fromMap(m)).toList();
  }

  static Future<List<Module>> getModules(int semesterId) async {
    final db = await database;
    final maps = await db.query('modules', where: 'semesterId = ?', whereArgs: [semesterId], orderBy: 'name ASC');
    return maps.map((m) => Module.fromMap(m)).toList();
  }

  static Future<List<Lesson>> getLessonsByModule(int moduleId) async {
    final db = await database;
    final maps = await db.query('lessons', where: 'moduleId = ?', whereArgs: [moduleId]);
    return maps.map((m) => Lesson.fromMap(m)).toList();
  }

  static Future<Lesson?> getLesson(int id) async {
    final db = await database;
    final maps = await db.query('lessons', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Lesson.fromMap(maps.first);
  }

  static Future<void> markLessonCompleted(int id) async {
    final db = await database;
    await db.update('lessons', {'isCompleted': 1}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Lesson>> getLessons({String? category}) async {
    final db = await database;
    final maps = category != null
        ? await db.query('lessons', where: 'category = ?', whereArgs: [category])
        : await db.query('lessons');
    return maps.map((m) => Lesson.fromMap(m)).toList();
  }

  static Future<List<Lesson>> searchLessons(String query) async {
    final db = await database;
    final maps = await db.query(
      'lessons',
      where: 'title LIKE ? OR content LIKE ? OR summary LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((m) => Lesson.fromMap(m)).toList();
  }

  static Future<List<GlossaryTerm>> getGlossaryTerms({String? category}) async {
    final db = await database;
    final maps = category != null
        ? await db.query('glossary_terms', where: 'category = ?', whereArgs: [category])
        : await db.query('glossary_terms', orderBy: 'termAr ASC');
    return maps.map((m) => GlossaryTerm.fromMap(m)).toList();
  }

  static Future<List<GlossaryTerm>> searchGlossary(String query) async {
    final db = await database;
    final maps = await db.query(
      'glossary_terms',
      where: 'termAr LIKE ? OR termFr LIKE ? OR definition LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((m) => GlossaryTerm.fromMap(m)).toList();
  }

  static Future<List<QuizQuestion>> getQuizQuestions({String? topic}) async {
    final db = await database;
    final maps = topic != null
        ? await db.query('quiz_questions', where: 'topic = ?', whereArgs: [topic])
        : await db.query('quiz_questions');
    return maps.map((m) => QuizQuestion.fromMap(m)).toList();
  }

  static Future<List<QuizQuestion>> getRandomQuestions({String? topic, int limit = 10}) async {
    final db = await database;
    final maps = topic != null
        ? await db.query('quiz_questions', where: 'topic = ?', whereArgs: [topic])
        : await db.query('quiz_questions');
    final questions = maps.map((m) => QuizQuestion.fromMap(m)).toList();
    questions.shuffle();
    return questions.take(limit).toList();
  }

  static Future<void> saveQuizResult(QuizResult result) async {
    final db = await database;
    await db.insert('quiz_results', result.toMap()..remove('id'));
  }

  static Future<List<QuizResult>> getQuizResults() async {
    final db = await database;
    final maps = await db.query('quiz_results', orderBy: 'date DESC');
    return maps.map((m) => QuizResult.fromMap(m)).toList();
  }

  static Future<List<UserProgress>> getUserProgress() async {
    final db = await database;
    final maps = await db.query('user_progress');
    return maps.map((m) => UserProgress.fromMap(m)).toList();
  }

  static Future<void> updateUserProgress(String category, int completed, int total) async {
    final db = await database;
    await db.insert(
      'user_progress',
      {'category': category, 'completedLessons': completed, 'totalLessons': total},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> getCompletedLessonsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM lessons WHERE isCompleted = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<int> getTotalLessonsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM lessons');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<double> getOverallQuizAverage() async {
    final db = await database;
    final result = await db.rawQuery('SELECT AVG(percentage) as avg FROM quiz_results');
    final avg = result.first['avg'];
    if (avg == null) return 0.0;
    return (avg as num).toDouble();
  }
}
