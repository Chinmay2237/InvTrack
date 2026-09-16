import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invtrack/features/handover_queue/presentation/handover_queue_screen.dart';

void main() {
  testWidgets('HandoverQueueScreen renders queue header title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HandoverQueueScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Pending Return Queue'), findsOneWidget);
  });
}
