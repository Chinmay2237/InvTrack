import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onActionPressed;
  final String? actionText;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.onActionPressed,
    this.actionText,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: theme.colorScheme.secondary),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onActionPressed != null && actionText != null)
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(actionText!),
                  onPressed: onActionPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
