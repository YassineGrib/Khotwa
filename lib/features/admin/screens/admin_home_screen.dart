import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routing/app_router.dart';
import '../widgets/admin_app_bar.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // قسم الإحصائيات المالية والعمولات
  double _subscriptionCommission = 0.15; // 15%
  double _consultationCommission = 0.20; // 20%
  int _monthlySubscriptions = 120; // عدد الاشتراكات الشهري (محاكاة)
  int _monthlyConsultations = 80; // عدد الاستشارات الشهري (محاكاة)
  final int _subscriptionPrice = 1000;
  final int _consultationPrice = 1500;

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
            curve: Curves.easeOutCubic,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  const SizedBox(height: 20),
                  _buildStatsCards(),
                  const SizedBox(height: 20),
                  _buildFinancialStatsCard(),
                  const SizedBox(height: 20),
                  _buildServicesGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AdminAppBar(
      title: 'لوحة التحكم',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white, size: 22),
          onPressed: () => _showNotifications(),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 22),
          onPressed: () => _showLogoutDialog(),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.adminColor,
            AppTheme.adminColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.adminColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dashboard, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك في لوحة التحكم',
                      style: AppTheme.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'إدارة شاملة لجميع جوانب منصة خطوة الطبية',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.white.withValues(alpha: 0.8)),
              const SizedBox(width: 6),
              Text(
                'آخر تسجيل دخول: اليوم ${TimeOfDay.now().format(context)}',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'المستخدمين',
            '1,234',
            Icons.people,
            AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'الأطباء',
            '156',
            Icons.medical_services,
            AppTheme.doctorColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'المراكز',
            '45',
            Icons.local_hospital,
            AppTheme.adminColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialStatsCard() {
    int yearlySubscriptions = _monthlySubscriptions * 12;
    int yearlyConsultations = _monthlyConsultations * 12;
    double monthlySubProfit = _monthlySubscriptions * _subscriptionPrice.toDouble();
    double yearlySubProfit = yearlySubscriptions * _subscriptionPrice.toDouble();
    double monthlyConsProfit = _monthlyConsultations * _consultationPrice * _consultationCommission;
    double yearlyConsProfit = yearlyConsultations * _consultationPrice * _consultationCommission;
    double totalMonthly = monthlySubProfit + monthlyConsProfit;
    double totalYearly = yearlySubProfit + yearlyConsProfit;
    return StatefulBuilder(
      builder: (context, setState) => Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_money, color: AppTheme.successColor, size: 28),
                  const SizedBox(width: 8),
                  Expanded(child: Text('الإحصائيات المالية والعمولات', style: AppTheme.titleLarge.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('عمولة الاستشارات (%)', style: AppTheme.bodyMedium),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _consultationCommission,
                                min: 0.05,
                                max: 0.5,
                                divisions: 9,
                                label: '${(_consultationCommission * 100).toInt()}%',
                                onChanged: (v) => setState(() => _consultationCommission = v),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('${(_consultationCommission * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildProfitTile('أرباح الاشتراكات', monthlySubProfit, yearlySubProfit, Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProfitTile('أرباح الاستشارات (بعد العمولة)', monthlyConsProfit, yearlyConsProfit, Colors.orange),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildProfitTile('مجموع الأرباح', totalMonthly, totalYearly, Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text('عدد الاشتراكات الشهرية: $_monthlySubscriptions', style: AppTheme.bodySmall)),
                  Expanded(child: Text('عدد الاستشارات الشهرية: $_monthlyConsultations', style: AppTheme.bodySmall)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfitTile(String title, double monthly, double yearly, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('شهرياً: ${monthly.toStringAsFixed(0)} دج', style: AppTheme.bodyMedium),
          Text('سنوياً: ${yearly.toStringAsFixed(0)} دج', style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    final services = [
      {
        'title': 'إدارة المستخدمين',
        'subtitle': 'إدارة حسابات المستخدمين',
        'icon': Icons.people_alt,
        'color': AppTheme.primaryColor,
        'route': AppRouter.adminUsers,
      },
      {
        'title': 'إدارة المحتوى',
        'subtitle': 'إدارة المقالات والنصائح الطبية',
        'icon': Icons.article,
        'color': AppTheme.successColor,
        'route': AppRouter.adminContent,
      },
      {
        'title': 'الشكاوى والدعم',
        'subtitle': 'متابعة شكاوى المستخدمين',
        'icon': Icons.support_agent,
        'color': AppTheme.warningColor,
        'route': AppRouter.adminComplaints,
      },
      {
        'title': 'التحليلات والإحصائيات',
        'subtitle': 'عرض إحصائيات النظام',
        'icon': Icons.analytics,
        'color': AppTheme.adminColor,
        'route': AppRouter.adminAnalytics,
      },
      {
        'title': 'إدارة المراكز',
        'subtitle': 'إدارة المراكز الطبية',
        'icon': Icons.local_hospital,
        'color': AppTheme.doctorColor,
        'route': AppRouter.adminCenters,
      },
      {
        'title': 'الإعدادات',
        'subtitle': 'إعدادات النظام العامة',
        'icon': Icons.settings,
        'color': AppTheme.textSecondary,
        'route': AppRouter.adminSettings,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخدمات الإدارية',
          style: AppTheme.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(service);
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, service['route']);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (service['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(service['icon'], color: service['color'], size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              service['title'],
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              service['subtitle'],
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
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تأكيد تسجيل الخروج'),
          content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.welcome,
      (route) => false,
    );
  }

  void _showNotifications() {
    // TODO: Implement notifications
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('الإشعارات'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
