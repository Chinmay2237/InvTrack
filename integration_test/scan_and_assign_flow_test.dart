import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end integration test: App startup and navigation shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InvTrackApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('InvTrack Dashboard'), findsOneWidget);
  });
}
