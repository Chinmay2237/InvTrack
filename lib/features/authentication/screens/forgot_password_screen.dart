
import 'package:flutter/material.dart';
import 'package:invtrack/core/services/auth_service.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _message;
  String? _errorMessage;

  Future<void> _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.sendPasswordResetEmail(_emailController.text);
        setState(() {
          _message = 'A password reset link has been sent to your email.';
          _errorMessage = null;
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
          _message = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an email' : null,
                ),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(_message!, style: const TextStyle(color: Colors.green)),
                  ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _sendResetLink,
                  child: const Text('Send Reset Link'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
