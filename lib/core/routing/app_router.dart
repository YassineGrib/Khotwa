import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/patient/screens/patient_home_screen.dart';
import '../../features/patient/screens/medical_profile_screen.dart';
import '../../features/patient/screens/consultations_screen.dart';
import '../../features/patient/screens/nearby_centers_screen.dart';
import '../../features/patient/screens/chat_screen.dart';
import '../../features/patient/screens/treatment_tracking_screen.dart';
import '../../features/patient/screens/educational_content_screen.dart';
import '../../features/patient/screens/medical_store_screen.dart';
import '../../features/doctor/screens/doctor_home_screen.dart';
import '../../features/doctor/screens/professional_profile_screen.dart';
import '../../features/doctor/screens/doctor_consultations_screen.dart';
import '../../features/doctor/screens/doctor_chat_screen.dart';
import '../../features/doctor/screens/doctor_schedule_screen.dart';
import '../../features/doctor/screens/doctor_calendar_screen.dart';
import '../../features/admin/screens/admin_home_screen.dart';
import '../../features/admin/screens/admin_users_screen.dart';
import '../../features/admin/screens/admin_content_screen.dart';
import '../../features/admin/screens/admin_complaints_screen.dart';
import '../../features/admin/screens/admin_analytics_screen.dart';
import '../../features/admin/screens/admin_centers_screen.dart';
import '../../features/admin/screens/admin_settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String patientHome = '/patient-home';
  static const String medicalProfile = '/medical-profile';
  static const String consultations = '/consultations';
  static const String nearbyCenters = '/nearby-centers';
  static const String chat = '/chat';
  static const String doctorHome = '/doctor-home';
  static const String adminHome = '/admin-home';

  // Patient routes
  static const String patientProfile = '/patient/profile';
  static const String patientConsultations = '/patient/consultations';
  static const String patientNearbyCenter = '/patient/nearby-centers';
  static const String patientChat = '/patient/chat';
  static const String patientTreatment = '/patient/treatment';
  static const String patientEducation = '/patient/education';
  static const String patientStore = '/patient/store';

  // Doctor routes
  static const String doctorProfile = '/doctor/profile';
  static const String doctorConsultations = '/doctor/consultations';
  static const String doctorChat = '/doctor/chat';
  static const String doctorSchedule = '/doctor/schedule';
  static const String doctorCalendar = '/doctor/calendar';

  // Admin routes
  static const String adminUsers = '/admin/users';
  static const String adminContent = '/admin/content';
  static const String adminComplaints = '/admin/complaints';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminCenters = '/admin/centers';
  static const String adminSettings = '/admin/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);
      case welcome:
        return _buildRoute(const WelcomeScreen(), settings);
      case login:
        return _buildRoute(const LoginScreen(), settings);
      case register:
        return _buildRoute(const RegisterScreen(), settings);
      case patientHome:
        return _buildRoute(const PatientHomeScreen(), settings);
      case medicalProfile:
        return _buildRoute(const MedicalProfileScreen(), settings);
      case consultations:
        return _buildRoute(const ConsultationsScreen(), settings);
      case nearbyCenters:
        return _buildRoute(const NearbyCentersScreen(), settings);
      case chat:
        return _buildRoute(const ChatScreen(), settings);
      case patientTreatment:
        return _buildRoute(const TreatmentTrackingScreen(), settings);
      case patientEducation:
        return _buildRoute(const EducationalContentScreen(), settings);
      case patientStore:
        return _buildRoute(const MedicalStoreScreen(), settings);
      case doctorHome:
        return _buildRoute(const DoctorHomeScreen(), settings);
      case doctorProfile:
        return _buildRoute(const ProfessionalProfileScreen(), settings);
      case doctorConsultations:
        return _buildRoute(const DoctorConsultationsScreen(), settings);
      case doctorChat:
        return _buildRoute(const DoctorChatScreen(), settings);
      case doctorSchedule:
        return _buildRoute(const DoctorScheduleScreen(), settings);
      case doctorCalendar:
        return _buildRoute(const DoctorCalendarScreen(), settings);
      case adminHome:
        return _buildRoute(const AdminHomeScreen(), settings);
      case adminUsers:
        return _buildRoute(const AdminUsersScreen(), settings);
      case adminContent:
        return _buildRoute(const AdminContentScreen(), settings);
      case adminComplaints:
        return _buildRoute(const AdminComplaintsScreen(), settings);
      case adminAnalytics:
        return _buildRoute(const AdminAnalyticsScreen(), settings);
      case adminCenters:
        return _buildRoute(const AdminCentersScreen(), settings);
      case adminSettings:
        return _buildRoute(const AdminSettingsScreen(), settings);
      default:
        return _buildRoute(
          const Scaffold(body: Center(child: Text('الصفحة غير موجودة'))),
          settings,
        );
    }
  }

  static PageRoute _buildRoute(Widget child, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Navigation helpers
  static void navigateToWelcome(BuildContext context) {
    Navigator.pushReplacementNamed(context, welcome);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, login);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, register);
  }

  static void navigateToPatientHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, patientHome);
  }

  static void navigateToDoctorHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, doctorHome);
  }

  static void navigateToAdminHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, adminHome);
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
}
