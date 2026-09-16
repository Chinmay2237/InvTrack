import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/currency_formatter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _businessNameController = TextEditingController(text: 'Acme Operations Corp');
  final _warehouseController = TextEditingController(text: 'Main Logistics Hub');
  AppCurrency _selectedCurrency = AppCurrency.usd;

  @override
  void dispose() {
    _businessNameController.dispose();
    _warehouseController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Welcome to InvTrack, ${_businessNameController.text}! Setup completed.')),
    );
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTokens.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.boxes, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome to InvTrack v2',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your workspace and initial inventory warehouse in 30 seconds.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        controller: _businessNameController,
                        decoration: const InputDecoration(
                          labelText: 'Business / Company Name',
                          prefixIcon: Icon(LucideIcons.building, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _warehouseController,
                        decoration: const InputDecoration(
                          labelText: 'Primary Warehouse Hub Name',
                          prefixIcon: Icon(LucideIcons.warehouse, size: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<AppCurrency>(
                        initialValue: _selectedCurrency,
                        decoration: const InputDecoration(
                          labelText: 'Operating Base Currency',
                          prefixIcon: Icon(LucideIcons.dollar_sign, size: 18),
                        ),
                        items: AppCurrency.values
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text('${c.code} (${c.symbol})'),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCurrency = val);
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _completeOnboarding,
                          icon: const Icon(LucideIcons.arrow_right),
                          label: const Text('Initialize InvTrack Studio'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
