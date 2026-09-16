import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/features/scanning/presentation/scanning_screen.dart';

void main() {
  testWidgets('ScanningScreen renders scan station title and mode chips', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ScanningScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Scan Station'), findsOneWidget);
    expect(find.text('Single Mode'), findsOneWidget);
  });
}
