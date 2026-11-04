import 'package:flutter_test/flutter_test.dart';
import 'package:pj_masks/main.dart';

void main() {
  testWidgets('PJ Masks app loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const PJMasksApp());
    expect(find.byType(PJMasksApp), findsOneWidget);
  });
}
