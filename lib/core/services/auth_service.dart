import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  // Get current user
  UserModel? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Get user role
  String? get userRole => _currentUser?.role;

  // Initialize auth service (check for saved user)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson);
        _currentUser = UserModel.fromJson(userMap);
      } catch (e) {
        // Clear invalid user data
        await logout();
      }
    }
  }

  // Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, we'll use hardcoded users
      // In a real app, this would make an API call
      final user = await _authenticateUser(email, password);

      if (user != null) {
        _currentUser = user;
        await _saveUserToPrefs(user);
        return AuthResult.success(user);
      } else {
        return AuthResult.failure(ErrorMessages.invalidCredentials);
      }
    } catch (e) {
      return AuthResult.failure(ErrorMessages.networkError);
    }
  }

  // Register new user
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if email already exists (demo logic)
      if (await _emailExists(email)) {
        return AuthResult.failure(ErrorMessages.emailAlreadyExists);
      }

      // Create new user
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        role: role,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        isVerified: false,
      );

      _currentUser = user;
      await _saveUserToPrefs(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure(ErrorMessages.networkError);
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userRoleKey);
    await prefs.remove(AppConstants.userIdKey);
  }

  // Update user profile
  Future<AuthResult> updateProfile(UserModel updatedUser) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = updatedUser;
      await _saveUserToPrefs(updatedUser);
      return AuthResult.success(updatedUser);
    } catch (e) {
      return AuthResult.failure(ErrorMessages.networkError);
    }
  }

  // Change password
  Future<AuthResult> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // In a real app, verify current password with backend
      // For demo, we'll assume it's successful
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.failure(ErrorMessages.networkError);
    }
  }

  // Reset password
  Future<AuthResult> resetPassword(String email) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would send a reset email
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(ErrorMessages.networkError);
    }
  }

  // Private helper methods
  Future<UserModel?> _authenticateUser(String email, String password) async {
    // Demo users for testing
    final demoUsers = [
      {
        'email': 'patient@khatwa.com',
        'password': '123456',
        'name': 'أحمد محمد',
        'role': AppConstants.rolePatient,
        'phoneNumber': '+213555123456',
      },
      {
        'email': 'doctor@khatwa.com',
        'password': '123456',
        'name': 'د. فاطمة بن علي',
        'role': AppConstants.roleDoctor,
        'phoneNumber': '+213555654321',
      },
      {
        'email': 'admin@khatwa.com',
        'password': '123456',
        'name': 'مدير النظام',
        'role': AppConstants.roleAdmin,
        'phoneNumber': '+213555999888',
      },
    ];

    for (final userData in demoUsers) {
      if (userData['email'] == email && userData['password'] == password) {
        return UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: userData['email']!,
          name: userData['name']!,
          role: userData['role']!,
          phoneNumber: userData['phoneNumber'],
          createdAt: DateTime.now(),
          isVerified: true,
        );
      }
    }
    return null;
  }

  Future<bool> _emailExists(String email) async {
    // Demo logic - in real app, check with backend
    final existingEmails = [
      'patient@khatwa.com',
      'doctor@khatwa.com',
      'admin@khatwa.com',
    ];
    return existingEmails.contains(email);
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user.toJson()));
    await prefs.setString(AppConstants.userRoleKey, user.role);
    await prefs.setString(AppConstants.userIdKey, user.id);
  }
}

// Auth result class
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? errorMessage;

  AuthResult._({required this.isSuccess, this.user, this.errorMessage});

  factory AuthResult.success(UserModel? user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}
