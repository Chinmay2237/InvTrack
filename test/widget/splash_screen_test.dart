import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/app.dart';

void main() {
  testWidgets('SplashScreen renders logo title and navigates to Dashboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InvTrackApp(),
      ),
    );

    // Initial frame shows SplashScreen
    expect(find.text('InvTrack'), findsWidgets);
    expect(find.text('Inventory, without the friction.'), findsOneWidget);

    // Advance time past splash delay
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify navigation to Dashboard Screen
    expect(find.text('InvTrack Dashboard'), findsOneWidget);
  });
}
