import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/app.dart';

void main() {
  testWidgets('SplashScreen renders logo title and navigates to Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InvTrackApp(),
      ),
    );

    // Initial frame shows SplashScreen
    expect(find.text('InvTrack v2'), findsOneWidget);
    expect(find.text('Commercial Asset & Warehouse Studio'), findsOneWidget);

    // Advance time past 1800ms splash delay
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify navigation to Dashboard Screen
    expect(find.text('InvTrack Dashboard'), findsOneWidget);
  });
}
