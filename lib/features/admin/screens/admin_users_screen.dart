import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/admin_app_bar.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _searchQuery = '';
  String _selectedFilter = 'الكل';
  final List<String> _filterOptions = [
    'الكل',
    'أطباء',
    'مرضى',
    'معلق',
    'مفعل',
    'محظور',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildSearchAndFilter(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPendingUsersTab(),
                      _buildActiveUsersTab(),
                      _buildBlockedUsersTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AdminAppBar(
      title: 'إدارة المستخدمين',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
          onPressed: _refreshData,
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white, size: 22),
          onPressed: _showFilterDialog,
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
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
          TextField(
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'البحث عن مستخدم...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppTheme.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.adminColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: AppTheme.backgroundColor,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'الفلتر: ',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.adminColor.withValues(
                            alpha: 0.2,
                          ),
                          checkmarkColor: AppTheme.adminColor,
                          labelStyle: AppTheme.bodySmall.copyWith(
                            color: isSelected
                                ? AppTheme.adminColor
                                : AppTheme.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.adminColor
                                : AppTheme.textSecondary.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.adminColor,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.adminColor,
        indicatorWeight: 3,
        labelStyle: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTheme.titleSmall,
        tabs: const [
          Tab(text: 'معلقة'),
          Tab(text: 'مفعلة'),
          Tab(text: 'محظورة'),
        ],
      ),
    );
  }

  Widget _buildPendingUsersTab() {
    return _buildUsersList(_getPendingUsers(), isPending: true);
  }

  Widget _buildActiveUsersTab() {
    return _buildUsersList(_getActiveUsers());
  }

  Widget _buildBlockedUsersTab() {
    return _buildUsersList(_getBlockedUsers(), isBlocked: true);
  }

  Widget _buildUsersList(
    List<Map<String, dynamic>> users, {
    bool isPending = false,
    bool isBlocked = false,
  }) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending
                  ? Icons.pending_actions
                  : isBlocked
                  ? Icons.block
                  : Icons.people,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isPending
                  ? 'لا توجد حسابات معلقة'
                  : isBlocked
                  ? 'لا توجد حسابات محظورة'
                  : 'لا توجد حسابات مفعلة',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user, isPending: isPending, isBlocked: isBlocked);
      },
    );
  }

  Widget _buildUserCard(
    Map<String, dynamic> user, {
    bool isPending = false,
    bool isBlocked = false,
  }) {
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: _getUserTypeColor(
                    user['type'],
                  ).withValues(alpha: 0.2),
                  child: Icon(
                    _getUserTypeIcon(user['type']),
                    color: _getUserTypeColor(user['type']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email'],
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(user['status']),
              ],
            ),
            const SizedBox(height: 12),
            _buildUserInfo(user),
            if (isPending || isBlocked) ...[
              const SizedBox(height: 16),
              _buildActionButtons(
                user,
                isPending: isPending,
                isBlocked: isBlocked,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = AppTheme.warningColor;
        text = 'معلق';
        break;
      case 'active':
        color = AppTheme.successColor;
        text = 'مفعل';
        break;
      case 'blocked':
        color = AppTheme.errorColor;
        text = 'محظور';
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

  Widget _buildUserInfo(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow('النوع', _getUserTypeText(user['type'])),
          _buildInfoRow('تاريخ التسجيل', user['registrationDate']),
          if (user['type'] == 'doctor') ...[
            _buildInfoRow('التخصص', user['specialization'] ?? 'غير محدد'),
            _buildInfoRow('رقم الترخيص', user['licenseNumber'] ?? 'غير محدد'),
          ],
          _buildInfoRow('رقم الهاتف', user['phone'] ?? 'غير محدد'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTheme.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    Map<String, dynamic> user, {
    bool isPending = false,
    bool isBlocked = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          if (isPending || isBlocked) ...[
            Row(
              children: [
                if (isPending) ...[
                  Expanded(
                    child: _buildActionButton(
                      onPressed: () => _approveUser(user),
                      icon: Icons.check_circle,
                      label: 'موافقة',
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      isElevated: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      onPressed: () => _rejectUser(user),
                      icon: Icons.cancel,
                      label: 'رفض',
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      isElevated: true,
                    ),
                  ),
                ],
                if (isBlocked) ...[
                  Expanded(
                    child: _buildActionButton(
                      onPressed: () => _unblockUser(user),
                      icon: Icons.lock_open_rounded,
                      label: 'إلغاء الحظر',
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                      isElevated: true,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          _buildActionButton(
            onPressed: () => _viewUserDetails(user),
            icon: Icons.visibility_outlined,
            label: 'عرض التفاصيل',
            backgroundColor: AppTheme.adminColor.withValues(alpha: 0.1),
            foregroundColor: AppTheme.adminColor,
            isElevated: false,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required bool isElevated,
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: isElevated
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: backgroundColor.withValues(alpha: 0.3),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: foregroundColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
            ),
    );
  }

  // Helper methods
  Color _getUserTypeColor(String type) {
    switch (type) {
      case 'doctor':
        return AppTheme.doctorColor;
      case 'patient':
        return AppTheme.primaryColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getUserTypeIcon(String type) {
    switch (type) {
      case 'doctor':
        return Icons.medical_services;
      case 'patient':
        return Icons.person;
      default:
        return Icons.help;
    }
  }

  String _getUserTypeText(String type) {
    switch (type) {
      case 'doctor':
        return 'طبيب';
      case 'patient':
        return 'مريض';
      default:
        return 'غير محدد';
    }
  }

  // Data methods
  List<Map<String, dynamic>> _getPendingUsers() {
    return [
      {
        'id': '1',
        'name': 'د. أحمد محمد',
        'email': 'ahmed.mohamed@example.com',
        'type': 'doctor',
        'status': 'pending',
        'registrationDate': '2024-01-15',
        'specialization': 'طب العظام',
        'licenseNumber': 'DOC123456',
        'phone': '+213551234567',
      },
      {
        'id': '2',
        'name': 'سارة أحمد',
        'email': 'sara.ahmed@example.com',
        'type': 'patient',
        'status': 'pending',
        'registrationDate': '2024-01-16',
        'phone': '+213507654321',
      },
    ];
  }

  List<Map<String, dynamic>> _getActiveUsers() {
    return [
      {
        'id': '3',
        'name': 'د. فاطمة علي',
        'email': 'fatima.ali@example.com',
        'type': 'doctor',
        'status': 'active',
        'registrationDate': '2024-01-10',
        'specialization': 'مرشد نفسي',
        'licenseNumber': 'DOC789012',
        'phone': '+213502345678',
      },
      {
        'id': '4',
        'name': 'محمد خالد',
        'email': 'mohamed.khalid@example.com',
        'type': 'patient',
        'status': 'active',
        'registrationDate': '2024-01-12',
        'phone': '+213508765432',
      },
    ];
  }

  List<Map<String, dynamic>> _getBlockedUsers() {
    return [
      {
        'id': '5',
        'name': 'عبدالله سعد',
        'email': 'abdullah.saad@example.com',
        'type': 'patient',
        'status': 'blocked',
        'registrationDate': '2024-01-08',
        'phone': '+213509876543',
      },
    ];
  }

  // Action methods
  void _refreshData() {
    setState(() {
      // Refresh data logic here
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تحديث البيانات'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خيارات الفلتر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filterOptions.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _approveUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الموافقة'),
        content: Text('هل أنت متأكد من الموافقة على حساب ${user['name']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم قبول حساب ${user['name']}'),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text('موافقة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _rejectUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الرفض'),
        content: Text('هل أنت متأكد من رفض حساب ${user['name']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم رفض حساب ${user['name']}'),
                  backgroundColor: AppTheme.errorColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('رفض', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _unblockUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الحظر'),
        content: Text('هل أنت متأكد من إلغاء حظر ${user['name']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إلغاء حظر ${user['name']}'),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text(
              'إلغاء الحظر',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _viewUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getUserTypeColor(
                      user['type'],
                    ).withValues(alpha: 0.2),
                    child: Icon(
                      _getUserTypeIcon(user['type']),
                      color: _getUserTypeColor(user['type']),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['email'],
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildUserInfo(user),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to edit user screen
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('تعديل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.adminColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _blockUser(user);
                      },
                      icon: const Icon(Icons.block, size: 18),
                      label: const Text('حظر'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
      ),
    );
  }

  void _blockUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حظر المستخدم'),
        content: Text('هل أنت متأكد من حظر ${user['name']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حظر ${user['name']}'),
                  backgroundColor: AppTheme.errorColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('حظر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
