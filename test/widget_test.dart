
import 'package:flutter_test/flutter_test.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:invtrack/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Renders LoginScreen initially', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the Login screen is shown
    expect(find.text('InvTrack'), findsOneWidget);
  });
}
