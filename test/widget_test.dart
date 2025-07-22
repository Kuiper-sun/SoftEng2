import 'package:flutter_test/flutter_test.dart';
import 'package:sariwai/main.dart';

void main() {
  testWidgets('Sariwai Welcome Screen loads properly', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Check if the welcome text or logo appears (adjust as needed)
    expect(find.text('Welcome to Sariwai'), findsOneWidget);

    // Or check if an image/logo loads
    // expect(find.byType(Image), findsWidgets); // optional if you use images
  });
}
