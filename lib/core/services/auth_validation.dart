class AuthValidation {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    
    if (value != password) {
      return 'كلمة المرور غير متطابقة';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    
    if (value.trim().length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    
    return null;
  }

  // Phone validation (optional)
  static String? validatePhoneOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    // Remove spaces and special characters for validation
    final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanPhone.length < 10) {
      return 'رقم الهاتف غير صحيح';
    }
    
    return null;
  }

  // Phone validation (required)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    
    return validatePhoneOptional(value);
  }

  // Age validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'العمر مطلوب';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'يرجى إدخال عمر صحيح';
    }
    
    if (age < 1 || age > 120) {
      return 'العمر يجب أن يكون بين 1 و 120 سنة';
    }
    
    return null;
  }

  // Medical ID validation
  static String? validateMedicalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرقم الطبي مطلوب';
    }
    
    if (value.length < 5) {
      return 'الرقم الطبي يجب أن يكون 5 أرقام على الأقل';
    }
    
    return null;
  }

  // Specialization validation
  static String? validateSpecialization(String? value) {
    if (value == null || value.isEmpty) {
      return 'التخصص مطلوب';
    }
    
    if (value.trim().length < 3) {
      return 'التخصص يجب أن يكون 3 أحرف على الأقل';
    }
    
    return null;
  }

  // License number validation
  static String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الترخيص مطلوب';
    }
    
    if (value.length < 6) {
      return 'رقم الترخيص يجب أن يكون 6 أرقام على الأقل';
    }
    
    return null;
  }

  // Years of experience validation
  static String? validateExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'سنوات الخبرة مطلوبة';
    }
    
    final experience = int.tryParse(value);
    if (experience == null) {
      return 'يرجى إدخال عدد صحيح';
    }
    
    if (experience < 0 || experience > 50) {
      return 'سنوات الخبرة يجب أن تكون بين 0 و 50 سنة';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  // Minimum length validation
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    
    if (value.length < minLength) {
      return '$fieldName يجب أن يكون $minLength أحرف على الأقل';
    }
    
    return null;
  }

  // Maximum length validation
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName يجب أن يكون $maxLength حرف كحد أقصى';
    }
    
    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(r'^https?:\/\/[^\s]+$');
    if (!urlRegex.hasMatch(value)) {
      return 'يرجى إدخال رابط صحيح';
    }
    
    return null;
  }

  // Date validation (for birth date, etc.)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'التاريخ مطلوب';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'يرجى إدخال تاريخ صحيح';
    }
  }

  // Weight validation
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'يرجى إدخال وزن صحيح';
    }
    
    if (weight < 1 || weight > 500) {
      return 'الوزن يجب أن يكون بين 1 و 500 كيلوغرام';
    }
    
    return null;
  }

  // Height validation
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'يرجى إدخال طول صحيح';
    }
    
    if (height < 50 || height > 250) {
      return 'الطول يجب أن يكون بين 50 و 250 سنتيمتر';
    }
    
    return null;
  }
}
