import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/admin_app_bar.dart';

class AdminCentersScreen extends StatefulWidget {
  const AdminCentersScreen({super.key});

  @override
  State<AdminCentersScreen> createState() => _AdminCentersScreenState();
}

class _AdminCentersScreenState extends State<AdminCentersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCity = 'الكل';
  String _selectedSpecialty = 'الكل';
  String _selectedStatus = 'الكل';
  String _searchQuery = '';

  final List<String> _cities = [
    'الكل',
    'سطيف',
    'الجزائر',
    'وهران',
    'قسنطينة',
    'عنابة',
    'باتنة',
    'بجاية',
    'تيزي وزو',
    'جيجل',
  ];

  final List<String> _specialties = [
    'الكل',
    'طب العظام',
    'فني تصنيع الأطراف الاصطناعية',
    'أخصائي التأهيل الحركي',
    'مرشد اجتماعي',
    'مرشد نفسي',
  ];

  final List<String> _statuses = [
    'الكل',
    'نشط',
    'معلق',
    'مرفوض',
    'قيد المراجعة',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  _buildCurrentTabContent(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddCenterDialog,
          backgroundColor: AppTheme.adminColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(
            'إضافة مركز',
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AdminAppBar(
      title: 'مراكز طبية جزائرية',
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white, size: 22),
          onPressed: () => _showAdvancedFilters(),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.adminColor,
        indicatorWeight: 3,
        labelColor: AppTheme.adminColor,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.titleSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.business),
            text: 'المراكز المعتمدة',
          ),
          Tab(
            icon: Icon(Icons.pending_actions),
            text: 'طلبات الإضافة',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    return IndexedStack(
      index: _tabController.index,
      children: [
        _buildApprovedCentersTab(),
        _buildPendingRequestsTab(),
      ],
    );
  }

  Widget _buildApprovedCentersTab() {
    return Column(
      children: [
        _buildFiltersSection(),
        const SizedBox(height: 16),
        _buildCentersList(),
      ],
    );
  }

  Widget _buildPendingRequestsTab() {
    return Column(
      children: [
        _buildRequestsFilters(),
        const SizedBox(height: 16),
        _buildRequestsList(),
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
              hintText: 'البحث في المراكز...',
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
                _buildFilterChip('المدينة', _selectedCity, _cities, (value) {
                  setState(() => _selectedCity = value);
                }),
                const SizedBox(width: 8),
                _buildFilterChip('التخصص', _selectedSpecialty, _specialties, (
                  value,
                ) {
                  setState(() => _selectedSpecialty = value);
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

  Widget _buildCentersList() {
    final centers = _getFilteredCenters();

    if (centers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_center,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد مراكز',
              style: AppTheme.titleSmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: centers.map((center) => _buildCenterCard(center)).toList(),
    );
  }

  Widget _buildCenterCard(Map<String, dynamic> center) {
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
                    color: _getStatusColor(
                      center['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_hospital,
                    color: _getStatusColor(center['status']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        center['name'],
                        style: AppTheme.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        center['specialty'],
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(center['status']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    center['address'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  center['phone'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: AppTheme.warningColor),
                const SizedBox(width: 4),
                Text(
                  '${center['rating']} (${center['reviews']} تقييم)',
                  style: AppTheme.bodyMedium.copyWith(
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
                    onPressed: () => _viewCenterDetails(center),
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
                    onPressed: () => _editCenter(center),
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

  Widget _buildRequestsFilters() {
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
          hintText: 'البحث في طلبات الإضافة...',
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

  Widget _buildRequestsList() {
    final requests = _getPendingRequests();

    if (requests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_actions,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد طلبات معلقة',
              style: AppTheme.titleSmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: requests.map((request) => _buildRequestCard(request)).toList(),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
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
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.pending,
                    color: AppTheme.warningColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['name'],
                        style: AppTheme.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'طلب بتاريخ: ${request['requestDate']}',
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
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'قيد المراجعة',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              request['description'],
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rejectRequest(request),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('رفض'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: BorderSide(color: AppTheme.errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveRequest(request),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('موافقة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
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
  List<Map<String, dynamic>> _getFilteredCenters() {
    List<Map<String, dynamic>> centers = [
      {
        'id': '1',
        'name': 'مركز سطيف لتأهيل ذوي الإعاقة والأطراف الاصطناعية',
        'specialty': 'تأهيل حركي وأطراف اصطناعية',
        'address': 'سطيف، الجزائر، شارع الاستقلال، حي الجامعة، رقم 15، الطابق الأول',
        'phone': '+213 36 12 34 56',
        'rating': 4.8,
        'reviews': 245,
        'status': 'نشط',
        'city': 'سطيف',
        'description': 'مركز متخصص في دعم مرضى الإعاقة وتقديم خدمات الأطراف الاصطناعية والتأهيل الحركي.',
      },
      {
        'id': '2',
        'name': 'مركز الجزائر للأطراف الاصطناعية والتأهيل',
        'specialty': 'أطراف اصطناعية وتأهيل',
        'address': 'الجزائر العاصمة، حي المدنية، شارع ديدوش مراد، رقم 25',
        'phone': '+213 36 23 45 67',
        'rating': 4.6,
        'reviews': 189,
        'status': 'نشط',
        'city': 'الجزائر',
        'description': 'خدمات متكاملة في تصنيع وتركيب الأطراف الاصطناعية وبرامج التأهيل لذوي الإعاقة.',
      },
      {
        'id': '3',
        'name': 'مركز وهران للدعم الحركي لذوي الإعاقة',
        'specialty': 'تأهيل حركي ودعم نفسي',
        'address': 'وهران، الجزائر، شارع الأمير عبد القادر، حي سيدي الهواري، رقم 10',
        'phone': '+213 36 34 56 78',
        'rating': 4.9,
        'reviews': 312,
        'status': 'معلق',
        'city': 'وهران',
        'description': 'تقديم برامج تأهيل حركي ودعم نفسي واجتماعي للأشخاص ذوي الإعاقة.',
      },
    ];

    return centers.where((center) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          center['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          center['specialty'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesCity =
          _selectedCity == 'الكل' || center['city'] == _selectedCity;
      final matchesSpecialty =
          _selectedSpecialty == 'الكل' ||
          center['specialty'] == _selectedSpecialty;
      final matchesStatus =
          _selectedStatus == 'الكل' || center['status'] == _selectedStatus;

      return matchesSearch && matchesCity && matchesSpecialty && matchesStatus;
    }).toList();
  }

  List<Map<String, dynamic>> _getPendingRequests() {
    return [
      {
        'id': '1',
        'name': 'مركز قسنطينة للأطراف الاصطناعية',
        'specialty': 'فني تصنيع الأطراف الاصطناعية',
        'description':
            'مركز متخصص في تصنيع وتركيب الأطراف الاصطناعية مع أحدث التقنيات في الجزائر',
        'requestDate': '2024-01-15',
        'requesterName': 'د. أحمد محمد',
        'requesterPhone': '+213 551 23 45 67',
      },
      {
        'id': '2',
        'name': 'مركز عنابة للتأهيل الحركي',
        'specialty': 'أخصائي التأهيل الحركي',
        'description': 'مركز حديث للتأهيل الحركي وبرامج إعادة التأهيل لذوي الإعاقة',
        'requestDate': '2024-01-20',
        'requesterName': 'د. فاطمة علي',
        'requesterPhone': '+213 551 34 56 78',
      },
    ];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'نشط':
        return AppTheme.successColor;
      case 'معلق':
        return AppTheme.warningColor;
      case 'مرفوض':
        return AppTheme.errorColor;
      case 'قيد المراجعة':
        return AppTheme.primaryColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: AppTheme.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Action Methods
  void _showAddCenterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة مركز جديد'),
        content: const Text('سيتم إضافة نموذج لإضافة مركز جديد'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال طلب إضافة المركز')),
              );
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _viewCenterDetails(Map<String, dynamic> center) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(center['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التخصص: ${center['specialty']}'),
            const SizedBox(height: 8),
            Text('العنوان: ${center['address']}'),
            const SizedBox(height: 8),
            Text('الهاتف: ${center['phone']}'),
            const SizedBox(height: 8),
            Text('التقييم: ${center['rating']} (${center['reviews']} تقييم)'),
            const SizedBox(height: 8),
            Text('الحالة: ${center['status']}'),
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

  void _editCenter(Map<String, dynamic> center) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تعديل ${center['name']}')));
  }

  void _approveRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('موافقة على الطلب'),
        content: Text('هل تريد الموافقة على طلب إضافة ${request['name']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم قبول طلب ${request['name']}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text('موافقة'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('رفض الطلب'),
        content: Text('هل تريد رفض طلب إضافة ${request['name']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم رفض طلب ${request['name']}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilters() {
    // TODO: Implement advanced filters dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('الفلترة المتقدمة'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showSettings() {
    // TODO: Implement centers settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('إعدادات المراكز'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
