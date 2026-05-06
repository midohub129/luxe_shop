import 'package:flutter_test/flutter_test.dart';
import 'package:luxe_shop/main.dart';

void main() {
  testWidgets('App renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LuxeShopApp());
    await tester.pump();
    expect(find.text('لوكس شوب'), findsOneWidget);
  });
}
