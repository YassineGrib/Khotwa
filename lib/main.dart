import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/auth_service.dart';
import 'core/models/user_model.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await AuthService().initialize();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const KhatwaApp());
}

class KhatwaApp extends StatelessWidget {
  const KhatwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here as needed
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,
        // Add localization support for Arabic
        locale: const Locale('ar', 'DZ'), // Arabic (Algeria)
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl, // Right-to-left for Arabic
            child: child!,
          );
        },
      ),
    );
  }
}

// Auth Provider for state management
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authService.isLoggedIn;
  UserModel? get currentUser => _authService.currentUser;
  String? get userRole => _authService.userRole;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    clearError();

    final result = await _authService.login(email, password);

    setLoading(false);

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      setError(result.errorMessage);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phoneNumber,
  }) async {
    setLoading(true);
    clearError();

    final result = await _authService.register(
      email: email,
      password: password,
      name: name,
      role: role,
      phoneNumber: phoneNumber,
    );

    setLoading(false);

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      setError(result.errorMessage);
      return false;
    }
  }

  Future<void> logout() async {
    setLoading(true);
    await _authService.logout();
    setLoading(false);
    notifyListeners();
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    setLoading(true);
    clearError();

    final result = await _authService.updateProfile(updatedUser);

    setLoading(false);

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      setError(result.errorMessage);
      return false;
    }
  }
}
