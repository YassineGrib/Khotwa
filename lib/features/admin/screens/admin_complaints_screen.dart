import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/admin_app_bar.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCategory = 'الكل';
  String _selectedPriority = 'الكل';
  String _selectedStatus = 'الكل';
  String _searchQuery = '';
  int _selectedTabIndex = 0;

  final List<String> _categories = [
    'الكل',
    'مشكلة تقنية',
    'شكوى من طبيب',
    'مشكلة في الدفع',
    'طلب تحسين',
    'مشكلة في المحتوى',
    'أخرى',
  ];

  final List<String> _priorities = ['الكل', 'عالية', 'متوسطة', 'منخفضة'];
  final List<String> _statuses = [
    'الكل',
    'جديدة',
    'قيد المراجعة',
    'مكتملة',
    'مرفوضة',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _tabController.dispose();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildTabBar(),
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddDialog,
          backgroundColor: AppTheme.adminColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(
            _selectedTabIndex == 0 ? 'إضافة شكوى' : 'إضافة ورشة',
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AdminAppBar(
      title: 'الشكاوى والدعم',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white, size: 22),
          onPressed: () => _showNotifications(),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white, size: 22),
          onPressed: () => _showSettings(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.adminColor,
        indicatorWeight: 4,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.adminColor,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.titleSmall.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: AppTheme.titleSmall.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            icon: Icon(Icons.report_problem, size: 20),
            text: 'الشكاوى',
            height: 56,
          ),
          Tab(
            icon: Icon(Icons.event, size: 20),
            text: 'ورش الدعم',
            height: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildComplaintsTab();
      case 1:
        return _buildWorkshopsTab();
      default:
        return _buildComplaintsTab();
    }
  }

  Widget _buildComplaintsTab() {
    return Column(
      children: [
        _buildFiltersSection(),
        _buildComplaintsList(),
      ],
    );
  }

  Widget _buildWorkshopsTab() {
    return Column(
      children: [
        _buildWorkshopFilters(),
        _buildWorkshopsList(),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'البحث في الشكاوى...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.adminColor),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('الفئة', _selectedCategory, _categories, (
                  value,
                ) {
                  setState(() => _selectedCategory = value);
                }),
                const SizedBox(width: 8),
                _buildFilterChip('الأولوية', _selectedPriority, _priorities, (
                  value,
                ) {
                  setState(() => _selectedPriority = value);
                }),
                const SizedBox(width: 8),
                _buildFilterChip('الحالة', _selectedStatus, _statuses, (value) {
                  setState(() => _selectedStatus = value);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map((option) => PopupMenuItem(value: option, child: Text(option)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selectedValue != 'الكل'
              ? AppTheme.adminColor.withValues(alpha: 0.1)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedValue != 'الكل'
                ? AppTheme.adminColor
                : AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $selectedValue',
              style: AppTheme.bodySmall.copyWith(
                color: selectedValue != 'الكل'
                    ? AppTheme.adminColor
                    : AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: selectedValue != 'الكل'
                  ? AppTheme.adminColor
                  : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsList() {
    final complaints = _getFilteredComplaints();

    if (complaints.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox,
                size: 80,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'لا توجد شكاوى',
                style: AppTheme.titleSmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: complaints.map((complaint) => _buildComplaintCard(complaint)).toList(),
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      complaint['priority'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(complaint['category']),
                    color: _getPriorityColor(complaint['priority']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint['title'],
                        style: AppTheme.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        complaint['category'],
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(complaint['status']),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              complaint['description'],
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  complaint['userName'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  complaint['date'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewComplaintDetails(complaint),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('عرض التفاصيل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.adminColor,
                      side: BorderSide(color: AppTheme.adminColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _updateComplaintStatus(complaint),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تحديث الحالة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.adminColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkshopFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'البحث في ورش الدعم...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.textSecondary.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.adminColor),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkshopsList() {
    final workshops = _getWorkshops();

    if (workshops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 80,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'لا توجد ورش دعم',
                style: AppTheme.titleSmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: workshops.map((workshop) => _buildWorkshopCard(workshop)).toList(),
      ),
    );
  }

  Widget _buildWorkshopCard(Map<String, dynamic> workshop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.event,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workshop['title'],
                        style: AppTheme.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workshop['type'],
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getWorkshopStatusColor(
                      workshop['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getWorkshopStatusColor(
                        workshop['status'],
                      ).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    workshop['status'],
                    style: AppTheme.bodySmall.copyWith(
                      color: _getWorkshopStatusColor(workshop['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              workshop['description'],
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  workshop['date'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  workshop['time'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.people, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${workshop['participants']} مشارك',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewWorkshopDetails(workshop),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('عرض التفاصيل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.adminColor,
                      side: BorderSide(color: AppTheme.adminColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editWorkshop(workshop),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تعديل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.adminColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'جديدة':
        color = AppTheme.warningColor;
        text = 'جديدة';
        break;
      case 'قيد المراجعة':
        color = AppTheme.primaryColor;
        text = 'قيد المراجعة';
        break;
      case 'مكتملة':
        color = AppTheme.successColor;
        text = 'مكتملة';
        break;
      case 'مرفوضة':
        color = AppTheme.errorColor;
        text = 'مرفوضة';
        break;
      default:
        color = AppTheme.textSecondary;
        text = 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppTheme.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالية':
        return AppTheme.errorColor;
      case 'متوسطة':
        return AppTheme.warningColor;
      case 'منخفضة':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'مشكلة تقنية':
        return Icons.bug_report;
      case 'شكوى من طبيب':
        return Icons.person_remove;
      case 'مشكلة في الدفع':
        return Icons.payment;
      case 'طلب تحسين':
        return Icons.lightbulb;
      case 'مشكلة في المحتوى':
        return Icons.content_paste;
      default:
        return Icons.help;
    }
  }

  Color _getWorkshopStatusColor(String status) {
    switch (status) {
      case 'مجدولة':
        return AppTheme.primaryColor;
      case 'جارية':
        return AppTheme.warningColor;
      case 'مكتملة':
        return AppTheme.successColor;
      case 'ملغية':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  List<Map<String, dynamic>> _getFilteredComplaints() {
    List<Map<String, dynamic>> complaints = [
      {
        'id': '1',
        'title': 'مشكلة في تسجيل الدخول',
        'description':
            'لا أستطيع تسجيل الدخول إلى التطبيق رغم إدخال البيانات الصحيحة',
        'category': 'مشكلة تقنية',
        'priority': 'عالية',
        'status': 'جديدة',
        'userName': 'أحمد محمد',
        'userEmail': 'ahmed@example.com',
        'date': '2024-01-15',
        'time': '10:30 ص',
      },
      {
        'id': '2',
        'title': 'طلب تحسين واجهة المستخدم',
        'description': 'أقترح تحسين تصميم الصفحة الرئيسية لتكون أكثر وضوحاً',
        'category': 'طلب تحسين',
        'priority': 'متوسطة',
        'status': 'قيد المراجعة',
        'userName': 'فاطمة علي',
        'userEmail': 'fatima@example.com',
        'date': '2024-01-14',
        'time': '02:15 م',
      },
      {
        'id': '3',
        'title': 'مشكلة في الدفع الإلكتروني',
        'description': 'تم خصم المبلغ من حسابي ولكن لم يتم تأكيد الحجز',
        'category': 'مشكلة في الدفع',
        'priority': 'عالية',
        'status': 'مكتملة',
        'userName': 'محمد حسن',
        'userEmail': 'mohammed@example.com',
        'date': '2024-01-13',
        'time': '11:45 ص',
      },
    ];

    // Apply filters
    if (_selectedCategory != 'الكل') {
      complaints = complaints
          .where((c) => c['category'] == _selectedCategory)
          .toList();
    }
    if (_selectedPriority != 'الكل') {
      complaints = complaints
          .where((c) => c['priority'] == _selectedPriority)
          .toList();
    }
    if (_selectedStatus != 'الكل') {
      complaints = complaints
          .where((c) => c['status'] == _selectedStatus)
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      complaints = complaints
          .where(
            (c) =>
                c['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c['description'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return complaints;
  }

  List<Map<String, dynamic>> _getWorkshops() {
    return [
      {
        'id': '1',
        'title': 'ورشة الدعم النفسي للمرضى',
        'description':
            'ورشة تهدف إلى تقديم الدعم النفسي والمعنوي للمرضى وأسرهم',
        'type': 'دعم نفسي',
        'date': '2024-01-20',
        'time': '03:00 م',
        'duration': '2 ساعة',
        'participants': 25,
        'maxParticipants': 30,
        'status': 'مجدولة',
        'instructor': 'د. سارة أحمد',
        'location': 'قاعة المؤتمرات الرئيسية',
      },
      {
        'id': '2',
        'title': 'ورشة التأهيل الحركي',
        'description':
            'تعليم تمارين التأهيل الحركي للمرضى بعد العمليات الجراحية',
        'type': 'تأهيل حركي',
        'date': '2024-01-18',
        'time': '10:00 ص',
        'duration': '3 ساعات',
        'participants': 15,
        'maxParticipants': 20,
        'status': 'جارية',
        'instructor': 'أ. محمد عبدالله',
        'location': 'صالة التمارين',
      },
      {
        'id': '3',
        'title': 'ورشة التغذية العلاجية',
        'description': 'تعليم أساسيات التغذية العلاجية للمرضى وأسرهم',
        'type': 'تغذية علاجية',
        'date': '2024-01-15',
        'time': '01:00 م',
        'duration': '2.5 ساعة',
        'participants': 20,
        'maxParticipants': 25,
        'status': 'مكتملة',
        'instructor': 'د. نور الهدى',
        'location': 'قاعة التدريب الثانية',
      },
    ];
  }

  // Action Methods
  void _showAddDialog() {
    if (_tabController.index == 0) {
      _showAddComplaintDialog();
    } else {
      _showAddWorkshopDialog();
    }
  }

  void _showAddComplaintDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة شكوى جديدة'),
        content: const Text('سيتم إضافة نموذج إضافة شكوى هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إضافة الشكوى بنجاح')),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddWorkshopDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة ورشة دعم جديدة'),
        content: const Text('سيتم إضافة نموذج إضافة ورشة هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إضافة الورشة بنجاح')),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _viewComplaintDetails(Map<String, dynamic> complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(complaint['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الفئة: ${complaint['category']}'),
            const SizedBox(height: 8),
            Text('الأولوية: ${complaint['priority']}'),
            const SizedBox(height: 8),
            Text('الحالة: ${complaint['status']}'),
            const SizedBox(height: 8),
            Text('المستخدم: ${complaint['userName']}'),
            const SizedBox(height: 8),
            Text('التاريخ: ${complaint['date']}'),
            const SizedBox(height: 12),
            const Text('الوصف:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(complaint['description']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _updateComplaintStatus(Map<String, dynamic> complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة الشكوى'),
        content: const Text('سيتم إضافة نموذج تحديث الحالة هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث حالة الشكوى')),
              );
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  void _viewWorkshopDetails(Map<String, dynamic> workshop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(workshop['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('النوع: ${workshop['type']}'),
            const SizedBox(height: 8),
            Text('التاريخ: ${workshop['date']}'),
            const SizedBox(height: 8),
            Text('الوقت: ${workshop['time']}'),
            const SizedBox(height: 8),
            Text('المدة: ${workshop['duration']}'),
            const SizedBox(height: 8),
            Text(
              'المشاركون: ${workshop['participants']}/${workshop['maxParticipants']}',
            ),
            const SizedBox(height: 8),
            Text('المدرب: ${workshop['instructor']}'),
            const SizedBox(height: 8),
            Text('المكان: ${workshop['location']}'),
            const SizedBox(height: 12),
            const Text('الوصف:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(workshop['description']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _editWorkshop(Map<String, dynamic> workshop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الورشة'),
        content: const Text('سيتم إضافة نموذج تعديل الورشة هنا'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث الورشة بنجاح')),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('عرض الإشعارات')),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('فتح الإعدادات')),
    );
  }
}
