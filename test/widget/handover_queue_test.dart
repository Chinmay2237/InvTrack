import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/features/handovers/presentation/handovers_overview_screen.dart';

void main() {
  testWidgets('HandoversOverviewScreen renders overdue queue workspace',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HandoversOverviewScreen(
            initialFilter: 'overdue',
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Asset Handovers'), findsOneWidget);
    expect(find.text('Overdue Queue'), findsAtLeast(1));
  });
}
