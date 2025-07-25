import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adopt/main.dart';


void main() {
  testWidgets('App renders Home Screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Pet Adoption'), findsOneWidget);
  });
}