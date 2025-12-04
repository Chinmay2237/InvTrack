import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssignsScreen extends StatelessWidget {
  const AssignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Products'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/assign/new'),
              child: const Text('Assign Product'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/assign/items'),
              child: const Text('View Assigned Products'),
            ),
          ],
        ),
      ),
    );
  }
}
