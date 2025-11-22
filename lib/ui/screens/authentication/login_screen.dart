import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _usernameShakeController;
  late Animation<double> _usernameShakeAnimation;

  late AnimationController _passwordShakeController;
  late Animation<double> _passwordShakeAnimation;

  @override
  void initState() {
    super.initState();

    _usernameShakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addListener(() {
        if (_usernameShakeController.isCompleted) {
          _usernameShakeController.reset();
        }
      });
    _usernameShakeAnimation = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
          parent: _usernameShakeController, curve: Curves.elasticOut),
    );

    _passwordShakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addListener(() {
        if (_passwordShakeController.isCompleted) {
          _passwordShakeController.reset();
        }
      });
    _passwordShakeAnimation = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
          parent: _passwordShakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameShakeController.dispose();
    _passwordShakeController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    bool isValid = true;

    // Manually validate and trigger shake animations
    if (_usernameController.text.isEmpty) {
      _usernameShakeController.forward(from: 0.0);
      isValid = false;
    }
    if (_passwordController.text.isEmpty) {
      _passwordShakeController.forward(from: 0.0);
      isValid = false;
    }

    if (!isValid) {
      // Show general error if validation fails for any field
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    try {
      await authService.signInWithUsernameAndPassword(
        _usernameController.text,
        _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        context.go('/'); // Navigate to dashboard on successful login
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'InvTrack',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _usernameShakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            sin(_usernameShakeAnimation.value * pi * 2) * 2, 0),
                        child: child,
                      );
                    },
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'admin',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      // Removed validator here, as we are triggering shake manually
                      // validator: (value) =>
                      //     value!.isEmpty ? 'Please enter your username' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _passwordShakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            sin(_passwordShakeAnimation.value * pi * 2) * 2, 0),
                        child: child,
                      );
                    },
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'InvTrack@123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      // Removed validator here, as we are triggering shake manually
                      // validator: (value) =>
                      //     value!.isEmpty ? 'Please enter your password' : null,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4.0,
                      ),
                      child: Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
