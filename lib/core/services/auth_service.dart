import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class AuthService with ChangeNotifier {
  bool _isLoggedIn = false;
  static const String _loggedInKey = 'isLoggedIn';

  AuthService() {
    _initAuthStatus();
  }

  Future<void> _initAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    notifyListeners();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> signInWithUsernameAndPassword(String username, String password) async {
    if (username == 'admin' && password == 'InvTrack@123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      _isLoggedIn = true;
      notifyListeners();
      debugPrint('[InvTrack] User "admin" logged in.');
    } else {
      debugPrint('[InvTrack] Invalid login attempt for username: $username');
      throw AuthException('Invalid credentials');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    _isLoggedIn = false;
    notifyListeners();
    debugPrint('[InvTrack] User logged out.');
  }

  // Removed Firebase Auth specific methods:
  // - createUserWithEmailAndPassword
  // - sendPasswordResetEmail
  // - authStateChanges stream
  // - user getter
}