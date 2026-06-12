import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nursing_helper_dz/core/theme/theme.dart';
import 'package:nursing_helper_dz/core/widgets/empty_state.dart';
import 'package:nursing_helper_dz/core/widgets/loading_view.dart';
import 'package:nursing_helper_dz/core/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard displays label and value', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: Row(
          children: [
            StatCard(label: 'الدروس', value: '5/10', color: AppTheme.successColor),
          ],
        ),
      ),
    ));
    expect(find.text('الدروس'), findsOneWidget);
    expect(find.text('5/10'), findsOneWidget);
  });

  testWidgets('EmptyState displays message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: EmptyState(icon: Icons.info, message: 'لا توجد بيانات'),
      ),
    ));
    expect(find.text('لا توجد بيانات'), findsOneWidget);
  });

  testWidgets('LoadingView displays without message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: LoadingView(),
      ),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingView displays with message', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Material(
        child: LoadingView(message: 'جاري التحميل...'),
      ),
    ));
    expect(find.text('جاري التحميل...'), findsOneWidget);
  });
}
