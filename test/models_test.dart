import 'package:flutter_test/flutter_test.dart';
import 'package:nursing_helper_dz/models/year.dart';
import 'package:nursing_helper_dz/models/semester.dart';
import 'package:nursing_helper_dz/models/module.dart';
import 'package:nursing_helper_dz/models/lesson.dart';
import 'package:nursing_helper_dz/models/glossary_term.dart';
import 'package:nursing_helper_dz/models/quiz_question.dart';
import 'package:nursing_helper_dz/models/quiz_result.dart';
import 'package:nursing_helper_dz/models/user_progress.dart';

void main() {
  group('Year', () {
    test('fromMap and toMap round trip', () {
      final map = {'id': 1, 'nameAr': 'السنة الأولى', 'nameFr': '1ère Année', 'orderIndex': 1};
      final year = Year.fromMap(map);
      expect(year.id, 1);
      expect(year.nameAr, 'السنة الأولى');
      expect(year.nameFr, '1ère Année');
      expect(year.orderIndex, 1);
      expect(year.toMap()['nameAr'], 'السنة الأولى');
    });
  });

  group('Semester', () {
    test('fromMap and toMap round trip', () {
      final map = {'id': 1, 'yearId': 1, 'name': 'S1', 'nameAr': 'السداسي الأول', 'orderIndex': 1};
      final sem = Semester.fromMap(map);
      expect(sem.id, 1);
      expect(sem.yearId, 1);
      expect(sem.name, 'S1');
      expect(sem.nameAr, 'السداسي الأول');
    });
  });

  group('Module', () {
    test('fromMap and toMap round trip', () {
      final map = {'id': 1, 'semesterId': 1, 'name': 'Test', 'nameAr': 'اختبار', 'description': 'وصف'};
      final module = Module.fromMap(map);
      expect(module.nameAr, 'اختبار');
      expect(module.description, 'وصف');
    });
  });

  group('Lesson', () {
    test('fromMap handles isCompleted as int', () {
      final map = {
        'id': 1, 'moduleId': 1, 'title': 'درس', 'category': 'تشريح',
        'academicYear': 'الأولى', 'content': 'محتوى', 'summary': 'ملخص',
        'keyPoints': 'نقاط', 'isCompleted': 1,
      };
      final lesson = Lesson.fromMap(map);
      expect(lesson.isCompleted, true);
    });

    test('fromMap handles isCompleted as 0', () {
      final map = {
        'id': 2, 'moduleId': 1, 'title': 'درس', 'category': 'تشريح',
        'academicYear': 'الأولى', 'content': 'محتوى', 'summary': 'ملخص',
        'keyPoints': 'نقاط', 'isCompleted': 0,
      };
      final lesson = Lesson.fromMap(map);
      expect(lesson.isCompleted, false);
    });
  });

  group('GlossaryTerm', () {
    test('fromMap and toMap round trip', () {
      final map = {'id': 1, 'termAr': 'قلب', 'termFr': 'Cœur', 'definition': 'عضو عضلي', 'category': 'التشريح'};
      final term = GlossaryTerm.fromMap(map);
      expect(term.termAr, 'قلب');
      expect(term.termFr, 'Cœur');
      expect(term.toMap()['termAr'], 'قلب');
    });
  });

  group('QuizQuestion', () {
    test('fromMap splits options correctly', () {
      final map = {
        'id': 1, 'question': 'سؤال?', 'options': 'خيار1||خيار2||خيار3||خيار4',
        'correctIndex': 0, 'topic': 'التشريح', 'explanation': 'شرح',
      };
      final q = QuizQuestion.fromMap(map);
      expect(q.options.length, 4);
      expect(q.options[0], 'خيار1');
      expect(q.correctIndex, 0);
    });

    test('toMap joins options correctly', () {
      final q = QuizQuestion(
        question: 'سؤال?',
        options: ['أ', 'ب', 'ج', 'د'],
        correctIndex: 2,
        topic: 'التمريض',
        explanation: 'شرح',
      );
      final map = q.toMap();
      expect(map['options'], 'أ||ب||ج||د');
    });
  });

  group('QuizResult', () {
    test('fromMap handles percentage as num', () {
      final map = {'id': 1, 'topic': 'التشريح', 'totalQuestions': 10, 'correctAnswers': 8, 'percentage': 80.0, 'date': '2024-01-01'};
      final r = QuizResult.fromMap(map);
      expect(r.percentage, 80.0);
      expect(r.correctAnswers, 8);
    });
  });

  group('UserProgress', () {
    test('percentage returns 0 when totalLessons is 0', () {
      final p = UserProgress(category: 'التشريح', completedLessons: 0, totalLessons: 0);
      expect(p.percentage, 0.0);
    });

    test('percentage calculates correctly', () {
      final p = UserProgress(category: 'التشريح', completedLessons: 3, totalLessons: 10);
      expect(p.percentage, 30.0);
    });
  });
}
