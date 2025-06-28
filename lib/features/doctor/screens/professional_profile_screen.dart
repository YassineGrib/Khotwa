import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _licenseController = TextEditingController();
  final _experienceController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _aboutController = TextEditingController();

  List<String> _certifications = [];
  List<String> _workingHours = [];
  String _selectedSpecialization = 'طب عام';

  final List<String> _specializations = [
    'طب عام',
    'طب الأطفال',
    'طب النساء والولادة',
    'طب القلب',
    'طب الأعصاب',
    'طب العظام',
    'طب الجلدية',
    'طب العيون',
    'طب الأنف والأذن والحنجرة',
    'الطب النفسي',
    'طب الأسنان',
    'الجراحة العامة',
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
    _loadProfileData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _specializationController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _clinicAddressController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    // Load existing profile data - will be implemented with actual data storage
    _nameController.text = 'د. أحمد محمد علي';
    _specializationController.text = 'طب القلب';
    _licenseController.text = 'LIC-2024-001234';
    _experienceController.text = '10 سنوات';
    _clinicAddressController.text = 'شارع الملك فهد، الرياض';
    _aboutController.text =
        'طبيب قلب متخصص مع خبرة واسعة في علاج أمراض القلب والأوعية الدموية';
    _certifications = ['شهادة البورد السعودي', 'شهادة الزمالة الأمريكية'];
    _workingHours = ['السبت - الخميس: 8:00 ص - 6:00 م'];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('الملف المهني'),
          backgroundColor: AppTheme.doctorColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildPersonalInfoSection(),
                    const SizedBox(height: 20),
                    _buildProfessionalInfoSection(),
                    const SizedBox(height: 20),
                    _buildCertificationsSection(),
                    const SizedBox(height: 20),
                    _buildWorkingHoursSection(),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.doctorGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.doctorColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppTheme.doctorColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _nameController.text.isNotEmpty
                ? _nameController.text
                : 'اسم الطبيب',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _specializationController.text.isNotEmpty
                ? _specializationController.text
                : 'التخصص',
            style: AppTheme.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatChip('التقييم', '4.8'),
              const SizedBox(width: 15),
              _buildStatChip('المرضى', '150+'),
              const SizedBox(width: 15),
              _buildStatChip('الخبرة', '10 سنوات'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection('المعلومات الشخصية', Icons.person_outline, [
      _buildTextField(
        controller: _nameController,
        label: 'الاسم الكامل',
        icon: Icons.person,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال الاسم الكامل';
          }
          return null;
        },
      ),
      const SizedBox(height: 15),
      _buildDropdownField(),
      const SizedBox(height: 15),
      _buildTextField(
        controller: _aboutController,
        label: 'نبذة عن الطبيب',
        icon: Icons.info_outline,
        maxLines: 3,
      ),
    ]);
  }

  Widget _buildProfessionalInfoSection() {
    return _buildSection('المعلومات المهنية', Icons.work_outline, [
      _buildTextField(
        controller: _licenseController,
        label: 'رقم الترخيص',
        icon: Icons.badge,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال رقم الترخيص';
          }
          return null;
        },
      ),
      const SizedBox(height: 15),
      _buildTextField(
        controller: _experienceController,
        label: 'سنوات الخبرة',
        icon: Icons.timeline,
      ),
      const SizedBox(height: 15),
      _buildTextField(
        controller: _clinicAddressController,
        label: 'عنوان العيادة',
        icon: Icons.location_on,
        maxLines: 2,
      ),
    ]);
  }

  Widget _buildCertificationsSection() {
    return _buildSection('الشهادات والمؤهلات', Icons.school, [
      ..._certifications.map((cert) => _buildCertificationItem(cert)),
      const SizedBox(height: 10),
      _buildAddButton('إضافة شهادة', _addCertification),
    ]);
  }

  Widget _buildWorkingHoursSection() {
    return _buildSection('ساعات العمل', Icons.access_time, [
      ..._workingHours.map((hour) => _buildWorkingHourItem(hour)),
      const SizedBox(height: 10),
      _buildAddButton('إضافة ساعات عمل', _addWorkingHour),
    ]);
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.doctorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.doctorColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.doctorColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.doctorColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecialization,
      decoration: InputDecoration(
        labelText: 'التخصص',
        prefixIcon: Icon(Icons.medical_services, color: AppTheme.doctorColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.doctorColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: _specializations.map((String specialization) {
        return DropdownMenuItem<String>(
          value: specialization,
          child: Text(specialization),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedSpecialization = newValue!;
          _specializationController.text = newValue;
        });
      },
    );
  }

  Widget _buildCertificationItem(String certification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.doctorColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.doctorColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: AppTheme.doctorColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              certification,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _removeCertification(certification),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHourItem(String hour) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.doctorColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.doctorColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: AppTheme.doctorColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hour,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _removeWorkingHour(hour),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.doctorColor,
          side: BorderSide(color: AppTheme.doctorColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.doctorColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save),
            const SizedBox(width: 10),
            Text(
              'حفظ الملف المهني',
              style: AppTheme.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _addCertification() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('إضافة شهادة'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'اسم الشهادة',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _certifications.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _addWorkingHour() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('إضافة ساعات عمل'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'ساعات العمل (مثال: السبت - الخميس: 8:00 ص - 6:00 م)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _workingHours.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _removeCertification(String certification) {
    setState(() {
      _certifications.remove(certification);
    });
  }

  void _removeWorkingHour(String hour) {
    setState(() {
      _workingHours.remove(hour);
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save profile data - will be implemented with actual data storage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ الملف المهني بنجاح'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
