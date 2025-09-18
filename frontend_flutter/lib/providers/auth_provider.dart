import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.login(email, password);
    _user = result;

    _isLoading = false;
    notifyListeners();

    return _user != null;
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    notifyListeners();
  }

  void checkAuth() {
    final supabaseUser = _apiService.currentUser();
    if (supabaseUser != null) {
      _user = UserModel(
        id: supabaseUser.id,
        name: '',
        email: supabaseUser.email ?? '',
        phone: '',
        role: 'citizen',
      );
    }
    notifyListeners();
  }
}
