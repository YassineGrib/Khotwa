import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.patientColor,
            AppTheme.patientColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.patientColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.waving_hand,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'مرحباً بك',
                                style: AppTheme.titleSmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authProvider.currentUser?.name ?? 'المريض',
                            style: AppTheme.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white, size: 26),
                      onPressed: () => _showNotificationsDialog(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.star, color: Colors.amber, size: 26),
                      onPressed: () => _showRatingDialog(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'اختر الخدمة التي تحتاجها',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
        children: [
          _buildServiceCard(
            context,
            'الملف الطبي',
            Icons.medical_information,
            'إنشاء وإدارة ملفك الطبي',
            () => _navigateToMedicalProfile(context),
            AppTheme.primaryColor,
          ),
          _buildServiceCard(
            context,
            'الاستشارات',
            Icons.chat_bubble_outline,
            'إرسال استشارة طبية',
            () => _navigateToConsultations(context),
            AppTheme.successColor,
          ),
          _buildServiceCard(
            context,
            'المراكز القريبة',
            Icons.location_on,
            'العثور على مراكز متخصصة',
            () => _navigateToNearbyCenters(context),
            AppTheme.warningColor,
          ),
          _buildServiceCard(
            context,
            'المحادثات',
            Icons.forum,
            'التواصل مع الأطباء',
            () => _navigateToChat(context),
            AppTheme.primaryColor,
          ),
          _buildServiceCard(
            context,
            'خطة العلاج',
            Icons.assignment,
            'متابعة خطة العلاج',
            () => _navigateToTreatment(context),
            AppTheme.adminColor,
          ),
          _buildServiceCard(
            context,
            'المحتوى التعليمي',
            Icons.school,
            'مقالات ونصائح طبية',
            () => _navigateToEducation(context),
            AppTheme.doctorColor,
          ),
          _buildServiceCard(
            context,
            'المتجر الطبي',
            Icons.shopping_cart,
            'أدوية ومعدات طبية',
            () => _navigateToStore(context),
            AppTheme.patientColor,
          ),
          _buildServiceCard(
            context,
            'الإعدادات',
            Icons.settings,
            'إعدادات الحساب',
            () => _showSettings(context),
            AppTheme.textSecondary,
          ),
          _buildServiceCard(
            context,
            'الاشتراك الشهري',
            Icons.subscriptions,
            'اشترك في خدمات التطبيق المميزة',
            () => Navigator.pushNamed(context, '/subscription'),
            AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToMedicalProfile(BuildContext context) {
    Navigator.pushNamed(context, '/medical-profile');
  }

  void _navigateToConsultations(BuildContext context) {
    Navigator.pushNamed(context, '/consultations');
  }

  void _navigateToNearbyCenters(BuildContext context) {
    Navigator.pushNamed(context, '/nearby-centers');
  }

  void _navigateToChat(BuildContext context) {
    Navigator.pushNamed(context, '/chat');
  }

  void _navigateToTreatment(BuildContext context) {
    Navigator.pushNamed(context, '/patient/treatment');
  }

  void _navigateToEducation(BuildContext context) {
    Navigator.pushNamed(context, '/patient/education');
  }

  void _navigateToStore(BuildContext context) {
    Navigator.pushNamed(context, '/patient/store');
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'الإعدادات',
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person, color: AppTheme.patientColor),
                title: const Text('الملف الشخصي'),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon(context, 'الملف الشخصي');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: AppTheme.patientColor,
                ),
                title: const Text('الإشعارات'),
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon(context, 'الإشعارات');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('تسجيل الخروج'),
                onTap: () => _logout(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/welcome');
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - قريباً'),
        backgroundColor: AppTheme.patientColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإشعارات'),
        content: const Text('لا توجد إشعارات حالياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقييم التطبيق'),
        content: const Text('يرجى تقييم تجربتك مع التطبيق.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
