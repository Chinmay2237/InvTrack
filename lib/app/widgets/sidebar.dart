import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  final Widget child;
  const Sidebar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Drawer(
              child: Column(
                children: [
                  const DrawerHeader(child: Text('InvTrack')),
                  ListTile(
                    title: const Text('Dashboard'),
                    onTap: () => context.go('/'),
                  ),
                  ListTile(
                    title: const Text('Laptops'),
                    onTap: () => context.go('/laptops'),
                  ),
                  ListTile(
                    title: const Text('Mobiles'),
                    onTap: () => context.go('/mobiles'),
                  ),
                  ListTile(
                    title: const Text('Accessories'),
                    onTap: () => context.go('/accessories'),
                  ),
                  ListTile(
                    title: const Text('Furniture'),
                    onTap: () => context.go('/furniture'),
                  ),
                  ListTile(
                    title: const Text('Others'),
                    onTap: () => context.go('/others'),
                  ),
                  ListTile(
                    title: const Text('CSV Import'),
                    onTap: () => context.go('/csv-import'),
                  ),
                  const Spacer(),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () => authService.signOut(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
