import 'package:flutter_test/flutter_test.dart';
import 'package:nursing_helper_dz/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const NursingHelperApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Nursing Helper DZ'), findsAtLeast(1));
  });
}
