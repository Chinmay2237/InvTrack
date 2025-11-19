import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/firestore_service.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: StreamBuilder<
          Map<String, int>>(
        stream: firestoreService.getCategoryCounts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final categoryCounts = snapshot.data ?? {};

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: categoryCounts.entries.map((entry) {
              return Card(
                child: InkWell(
                  onTap: () => context.go('/${entry.key}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(entry.key, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(entry.value.toString(), style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
