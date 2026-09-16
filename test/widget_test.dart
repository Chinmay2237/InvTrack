import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/app.dart';

void main() {
  testWidgets('InvTrackApp mounts cleanly with ProviderScope',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InvTrackApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify dashboard app header title exists
    expect(find.text('InvTrack Dashboard'), findsOneWidget);
  });
}
