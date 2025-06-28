import '../constants/app_constants.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.isVerified = false,
  });

  // Factory constructor for creating UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? AppConstants.rolePatient,
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'isVerified': isVerified,
    };
  }

  // Copy with method for updating user data
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  // Check if user is patient
  bool get isPatient => role == AppConstants.rolePatient;

  // Check if user is doctor
  bool get isDoctor => role == AppConstants.roleDoctor;

  // Check if user is admin
  bool get isAdmin => role == AppConstants.roleAdmin;

  // Get display name (first name only)
  String get displayName {
    final names = name.split(' ');
    return names.isNotEmpty ? names.first : name;
  }

  // Get initials for avatar
  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names.first.substring(0, 1).toUpperCase();
    }
    return 'U';
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Patient-specific model extending UserModel
class PatientModel extends UserModel {
  final String? medicalCondition;
  final String? emergencyContact;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final List<String> allergies;
  final List<String> medications;
  final String? address;

  PatientModel({
    required super.id,
    required super.email,
    required super.name,
    super.phoneNumber,
    super.profileImageUrl,
    required super.createdAt,
    super.updatedAt,
    super.isActive,
    super.isVerified,
    this.medicalCondition,
    this.emergencyContact,
    this.dateOfBirth,
    this.bloodType,
    this.allergies = const [],
    this.medications = const [],
    this.address,
  }) : super(role: AppConstants.rolePatient);

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      medicalCondition: json['medicalCondition'],
      emergencyContact: json['emergencyContact'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      bloodType: json['bloodType'],
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      address: json['address'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'medicalCondition': medicalCondition,
      'emergencyContact': emergencyContact,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'address': address,
    });
    return json;
  }

  // Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month || 
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}

// Doctor-specific model extending UserModel
class DoctorModel extends UserModel {
  final String specialization;
  final String licenseNumber;
  final List<String> certifications;
  final String? clinicAddress;
  final String? workExperience;
  final double rating;
  final int reviewCount;
  final bool isVerifiedDoctor;
  final List<String> workingHours;

  DoctorModel({
    required super.id,
    required super.email,
    required super.name,
    super.phoneNumber,
    super.profileImageUrl,
    required super.createdAt,
    super.updatedAt,
    super.isActive,
    super.isVerified,
    required this.specialization,
    required this.licenseNumber,
    this.certifications = const [],
    this.clinicAddress,
    this.workExperience,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerifiedDoctor = false,
    this.workingHours = const [],
  }) : super(role: AppConstants.roleDoctor);

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      specialization: json['specialization'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      certifications: List<String>.from(json['certifications'] ?? []),
      clinicAddress: json['clinicAddress'],
      workExperience: json['workExperience'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isVerifiedDoctor: json['isVerifiedDoctor'] ?? false,
      workingHours: List<String>.from(json['workingHours'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'certifications': certifications,
      'clinicAddress': clinicAddress,
      'workExperience': workExperience,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerifiedDoctor': isVerifiedDoctor,
      'workingHours': workingHours,
    });
    return json;
  }

  // Get formatted rating
  String get formattedRating => rating.toStringAsFixed(1);
}
