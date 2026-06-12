import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nursing_helper_dz/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Nursing Helper App - Full Integration Test', () {
    testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('الرائد للصحة'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Navigate through main screens', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // التحقق من شاشة البداية
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // الانتقال لشاشة السنوات
      await tester.tap(find.byIcon(Icons.school));
      await tester.pumpAndSettle();
      expect(find.text('السنوات الدراسية'), findsWidgets);

      // الانتقال للمسرد
      await tester.tap(find.byIcon(Icons.menu_book));
      await tester.pumpAndSettle();
      expect(find.text('المسرد'), findsWidgets);

      // الانتقال لشاشة التقدم
      await tester.tap(find.byIcon(Icons.trending_up));
      await tester.pumpAndSettle();
      expect(find.text('التقدم'), findsWidgets);

      // الانتقال للإعدادات
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('الإعدادات'), findsOneWidget);
    });

    testWidgets('Theme toggle works', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // انتقل للإعدادات
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // ابحث عن زر تبديل الوضع الليلي
      final switchFinder = find.byType(SwitchListTile);
      expect(switchFinder, findsOneWidget);

      // اضغط على المفتاح
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // تحقق من أن الموضوع قد تغير
      expect(find.text('مفعل'), findsWidgets);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // انتقل لشاشة البحث
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // أدخل نص بحث
      await tester.enterText(find.byType(TextField), 'تمريض');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // تحقق من أن النتائج تظهر أو رسالة "لا توجد نتائج"
      final listViewFound = find.byType(ListView).evaluate().isNotEmpty;
      final emptyTextFound = find.text('لا توجد نتائج للبحث').evaluate().isNotEmpty;
      expect(listViewFound || emptyTextFound, true);
    });

    testWidgets('Quiz flow works', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // انتقل لشاشة البداية
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // ابحث عن زر الاختبار السريع
      final quizButtonFinder = find.byIcon(Icons.quiz);
      if (quizButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(quizButtonFinder);
        await tester.pumpAndSettle();

        // تحقق من ظهور الأسئلة
        expect(find.byType(RadioListTile), findsWidgets);

        // حدد إجابة
        await tester.tap(find.byType(RadioListTile).first);
        await tester.pumpAndSettle();

        // اضغط زر التالي أو الإرسال
        final nextButtonFinder = find.text('التالي');
        final submitButtonFinder = find.text('إرسال');
        if (nextButtonFinder.evaluate().isNotEmpty) {
          await tester.tap(nextButtonFinder);
          await tester.pumpAndSettle();
        } else if (submitButtonFinder.evaluate().isNotEmpty) {
          await tester.tap(submitButtonFinder);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Data reset works', (WidgetTester tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // انتقل للإعدادات
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // ابحث عن زر إعادة التعيين
      final resetButtonFinder = find.text('إعادة تعيين البيانات');
      expect(resetButtonFinder, findsOneWidget);

      await tester.tap(resetButtonFinder);
      await tester.pumpAndSettle();

      // تحقق من ظهور حوار التأكيد
      expect(find.text('تأكيد'), findsWidgets);
      expect(find.text('إلغاء'), findsOneWidget);
    });
  });
}
