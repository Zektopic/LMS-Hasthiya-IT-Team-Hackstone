import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate login for now
    await Future.delayed(const Duration(seconds: 2));
    _isAuthenticated = true;
    
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
