import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_validation.dart';
import '../../../main.dart';

class MedicalProfileScreen extends StatefulWidget {
  const MedicalProfileScreen({super.key});

  @override
  State<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form controllers
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _medicalConditionController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedGender = 'ذكر';
  String _selectedBloodType = 'O+';
  bool _hasChronicDiseases = false;
  bool _takingMedications = false;
  bool _hasAllergies = false;
  bool _isLoading = false;

  final List<String> _genderOptions = ['ذكر', 'أنثى'];
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _medicalConditionController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _emergencyContactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('الملف الطبي'),
        backgroundColor: AppTheme.patientColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('المعلومات الأساسية'),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('المعلومات الطبية'),
                  _buildMedicalInfoSection(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('معلومات الطوارئ'),
                  _buildEmergencySection(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('ملاحظات إضافية'),
                  _buildNotesSection(),
                  const SizedBox(height: 40),
                  _buildSaveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: AppTheme.headlineSmall.copyWith(
          color: AppTheme.patientColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: AppTheme.getInputDecoration(
                    labelText: 'العمر',
                    prefixIcon: Icons.cake,
                  ),
                  validator: (value) => AuthValidation.validateAge(value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: AppTheme.getInputDecoration(
                    labelText: 'الجنس',
                    prefixIcon: Icons.person,
                  ),
                  items: _genderOptions.map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: AppTheme.getInputDecoration(
                    labelText: 'الوزن (كغ)',
                    prefixIcon: Icons.monitor_weight,
                  ),
                  validator: (value) => AuthValidation.validateWeight(value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: AppTheme.getInputDecoration(
                    labelText: 'الطول (سم)',
                    prefixIcon: Icons.height,
                  ),
                  validator: (value) => AuthValidation.validateHeight(value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedBloodType,
            decoration: AppTheme.getInputDecoration(
              labelText: 'فصيلة الدم',
              prefixIcon: Icons.bloodtype,
            ),
            items: _bloodTypes.map((bloodType) {
              return DropdownMenuItem(value: bloodType, child: Text(bloodType));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBloodType = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('لديك أمراض مزمنة؟'),
            value: _hasChronicDiseases,
            onChanged: (value) {
              setState(() {
                _hasChronicDiseases = value;
              });
            },
            activeColor: AppTheme.patientColor,
          ),
          if (_hasChronicDiseases) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicalConditionController,
              maxLines: 3,
              decoration: AppTheme.getInputDecoration(
                labelText: 'تفاصيل الحالة الطبية',
                prefixIcon: Icons.medical_information,
                hintText: 'اذكر الأمراض المزمنة والحالات الطبية...',
              ),
              validator: _hasChronicDiseases
                  ? (value) => AuthValidation.validateRequired(
                      value,
                      'تفاصيل الحالة الطبية',
                    )
                  : null,
            ),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('تتناول أدوية حالياً؟'),
            value: _takingMedications,
            onChanged: (value) {
              setState(() {
                _takingMedications = value;
              });
            },
            activeColor: AppTheme.patientColor,
          ),
          if (_takingMedications) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicationsController,
              maxLines: 3,
              decoration: AppTheme.getInputDecoration(
                labelText: 'الأدوية الحالية',
                prefixIcon: Icons.medication,
                hintText: 'اذكر الأدوية التي تتناولها والجرعات...',
              ),
              validator: _takingMedications
                  ? (value) => AuthValidation.validateRequired(
                      value,
                      'الأدوية الحالية',
                    )
                  : null,
            ),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('لديك حساسية من أدوية أو مواد؟'),
            value: _hasAllergies,
            onChanged: (value) {
              setState(() {
                _hasAllergies = value;
              });
            },
            activeColor: AppTheme.patientColor,
          ),
          if (_hasAllergies) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _allergiesController,
              maxLines: 2,
              decoration: AppTheme.getInputDecoration(
                labelText: 'الحساسية',
                prefixIcon: Icons.warning,
                hintText: 'اذكر المواد أو الأدوية التي تسبب لك حساسية...',
              ),
              validator: _hasAllergies
                  ? (value) =>
                        AuthValidation.validateRequired(value, 'الحساسية')
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _emergencyContactController,
        keyboardType: TextInputType.phone,
        decoration: AppTheme.getInputDecoration(
          labelText: 'رقم الطوارئ',
          prefixIcon: Icons.emergency,
          hintText: 'رقم هاتف شخص للتواصل معه في حالات الطوارئ',
        ),
        validator: (value) => AuthValidation.validatePhone(value),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _notesController,
        maxLines: 4,
        decoration: AppTheme.getInputDecoration(
          labelText: 'ملاحظات إضافية',
          prefixIcon: Icons.note,
          hintText: 'أي معلومات إضافية تريد إضافتها لملفك الطبي...',
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.patientColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'حفظ الملف الطبي',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Save medical profile to backend

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم حفظ الملف الطبي بنجاح'),
            backgroundColor: AppTheme.patientColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
