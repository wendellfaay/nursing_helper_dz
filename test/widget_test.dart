import 'package:flutter_test/flutter_test.dart';
import 'package:nursing_helper_dz/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const NursingHelperApp());
    expect(find.text('Nursing Helper DZ'), findsOneWidget);
  });
}
