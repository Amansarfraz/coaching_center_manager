import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _currentUser?.role;

  // ---------------- LOGIN ----------------
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(email: email, password: password);

    _isLoading = false;

    if (result['success'] == true) {
      _currentUser = result['user'];
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  // ---------------- SIGNUP ----------------
  Future<bool> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.signup(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );

    _isLoading = false;

    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // ---------------- CHECK IF ALREADY LOGGED IN (on app start) ----------------
  Future<bool> checkLoginStatus() async {
    final loggedIn = await LocalStorageService.isLoggedIn();
    if (loggedIn) {
      final userId = await LocalStorageService.getUserId();
      final userName = await LocalStorageService.getUserName();
      final role = await LocalStorageService.getUserRole();

      if (userId != null && userName != null && role != null) {
        _currentUser = UserModel(
          id: userId,
          fullName: userName,
          email: '',
          phone: '',
          role: role,
          createdAt: DateTime.now(),
        );
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }
    }
    _isLoggedIn = false;
    notifyListeners();
    return false;
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // ---------------- CLEAR ERROR ----------------
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
