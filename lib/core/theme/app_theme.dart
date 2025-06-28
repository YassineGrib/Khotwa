import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Color Scheme
  static const Color patientColor = Color(AppConstants.patientColorValue);
  static const Color doctorColor = Color(AppConstants.doctorColorValue);
  static const Color adminColor = Color(AppConstants.adminColorValue);

  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient patientGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient doctorGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient adminGradient = LinearGradient(
    colors: [Color(0xFFF44336), Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: AppConstants.cairoFont,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: AppConstants.cairoFont,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: AppConstants.cairoFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: AppConstants.cairoFont,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: AppConstants.cairoFont,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: AppConstants.cairoFont,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textOnPrimary,
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    ),
    textStyle: const TextStyle(
      fontFamily: AppConstants.tajawalFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor, width: 2),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    ),
    textStyle: const TextStyle(
      fontFamily: AppConstants.tajawalFont,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  // Input Decoration
  static InputDecoration getInputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: textLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: textLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(
        fontFamily: AppConstants.cairoFont,
        color: textSecondary,
      ),
      hintStyle: const TextStyle(
        fontFamily: AppConstants.cairoFont,
        color: textLight,
      ),
    );
  }

  // Card Theme
  static CardThemeData get cardTheme => CardThemeData(
    elevation: AppConstants.cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
    ),
    color: surfaceColor,
    margin: const EdgeInsets.all(AppConstants.smallPadding),
  );

  // App Bar Theme
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: textOnPrimary,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontFamily: AppConstants.tajawalFont,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textOnPrimary,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
    ),
  );

  // Admin App Bar Style - Consistent styling for all admin screens
  static TextStyle get adminAppBarTitle => const TextStyle(
    fontFamily: AppConstants.tajawalFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get bottomNavTheme =>
      const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: AppConstants.cairoFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppConstants.cairoFont,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      );

  // Main Theme Data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    fontFamily: AppConstants.cairoFont,
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: cardTheme,
    appBarTheme: appBarTheme,
    bottomNavigationBarTheme: bottomNavTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButtonStyle),
  );
}

// Role-based theme extensions
extension RoleTheme on AppTheme {
  static Color getRoleColor(String role) {
    switch (role) {
      case AppConstants.rolePatient:
        return AppTheme.patientColor;
      case AppConstants.roleDoctor:
        return AppTheme.doctorColor;
      case AppConstants.roleAdmin:
        return AppTheme.adminColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  static LinearGradient getRoleGradient(String role) {
    switch (role) {
      case AppConstants.rolePatient:
        return AppTheme.patientGradient;
      case AppConstants.roleDoctor:
        return AppTheme.doctorGradient;
      case AppConstants.roleAdmin:
        return AppTheme.adminGradient;
      default:
        return AppTheme.primaryGradient;
    }
  }
}
