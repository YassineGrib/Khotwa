// App Constants for Khotwa Application
class AppConstants {
  // App Information
  static const String appName = 'خطوة - Khotwa';
  static const String appSlogan = 'نحو حياة أفضل ومستقبل أعظم';
  static const String appVersion = '1.0.0';
  
  // User Roles
  static const String rolePatient = 'المستخدم';
  static const String roleDoctor = 'المختص';
  static const String roleAdmin = 'المشرف';
  
  // Colors (Material Color Values)
  static const int patientColorValue = 0xFF2196F3; // Blue
  static const int doctorColorValue = 0xFF4CAF50;  // Green
  static const int adminColorValue = 0xFFF44336;   // Red
  
  // API Endpoints (for future backend integration)
  static const String baseUrl = 'https://api.khotwa.com';
  static const String authEndpoint = '/auth';
  static const String patientsEndpoint = '/patients';
  static const String doctorsEndpoint = '/doctors';
  static const String adminEndpoint = '/admin';
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
  static const String isFirstLaunchKey = 'is_first_launch';
  
  // Asset Paths
  static const String logoPath = 'assets/images/khotwa_logo.png';
  static const String welcomeVideoPath = 'assets/videos/welcome.mp4';
  static const String iconsPath = 'assets/icons/';
  static const String animationsPath = 'assets/animations/';
  
  // Font Families
  static const String cairoFont = 'Cairo';
  static const String tajawalFont = 'Tajawal';
  static const String amiriFont = 'Amiri';
  
  // Setif, Algeria Location (Default location)
  static const double setifLatitude = 36.1919;
  static const double setifLongitude = 5.4133;
  
  // App Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Animation Durations
  static const int shortAnimationDuration = 300;
  static const int mediumAnimationDuration = 500;
  static const int longAnimationDuration = 800;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Chat and Messaging
  static const int maxMessageLength = 1000;
  static const int messagesPerPage = 20;
  
  // Medical Equipment Store
  static const int productsPerPage = 10;
  static const double minPrice = 0.0;
  static const double maxPrice = 100000.0;
}

// Route Names
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String patientHome = '/patient';
  static const String doctorHome = '/doctor';
  static const String adminHome = '/admin';
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String map = '/map';
  static const String store = '/store';
  static const String calendar = '/calendar';
  static const String settings = '/settings';
}

// Error Messages
class ErrorMessages {
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم';
  static const String invalidCredentials = 'بيانات الدخول غير صحيحة';
  static const String userNotFound = 'المستخدم غير موجود';
  static const String emailAlreadyExists = 'البريد الإلكتروني مستخدم بالفعل';
  static const String weakPassword = 'كلمة المرور ضعيفة';
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String locationPermissionDenied = 'تم رفض إذن الموقع';
  static const String cameraPermissionDenied = 'تم رفض إذن الكاميرا';
  static const String storagePermissionDenied = 'تم رفض إذن التخزين';
}

// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String registerSuccess = 'تم إنشاء الحساب بنجاح';
  static const String profileUpdated = 'تم تحديث الملف الشخصي';
  static const String messageSent = 'تم إرسال الرسالة';
  static const String appointmentBooked = 'تم حجز الموعد';
  static const String consultationSent = 'تم إرسال الاستشارة';
}
