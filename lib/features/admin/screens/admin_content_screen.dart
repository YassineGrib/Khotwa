import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/admin_app_bar.dart';

class AdminContentScreen extends StatefulWidget {
  const AdminContentScreen({super.key});

  @override
  State<AdminContentScreen> createState() => _AdminContentScreenState();
}

class _AdminContentScreenState extends State<AdminContentScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  String _selectedStatus = 'الكل';
  int _selectedTabIndex = 0; // Track selected tab

  final List<String> _categories = [
    'الكل',
    'التمارين',
    'التغذية',
    'العلاج الطبيعي',
    'الدعم النفسي',
    'التكنولوجيا المساعدة',
    'الحياة اليومية',
  ];

  final List<String> _statusOptions = [
    'الكل',
    'منشور',
    'مسودة',
    'في المراجعة',
    'مرفوض',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                  _buildSearchAndFilters(),
                  const SizedBox(height: 8),
                  _buildAnalyticsDashboard(),
                  const SizedBox(height: 8),
                  _buildTabBar(),
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AdminAppBar(
      title: 'إدارة المحتوى',
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

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'البحث في المحتوى...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              prefixIcon: const Icon(Icons.search, color: AppTheme.adminColor),
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
          ),
          const SizedBox(height: 8),
          // Filter Chips
          Row(
            children: [
              Text(
                'الفئة: ',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = category);
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppTheme.adminColor.withValues(
                              alpha: 0.2,
                            ),
                            checkmarkColor: AppTheme.adminColor,
                            labelStyle: AppTheme.bodySmall.copyWith(
                              color: _selectedCategory == category
                                  ? AppTheme.adminColor
                                  : AppTheme.textSecondary,
                              fontWeight: _selectedCategory == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: _selectedCategory == category
                                  ? AppTheme.adminColor
                                  : AppTheme.textSecondary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'الحالة: ',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._statusOptions.map(
                        (status) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: FilterChip(
                            label: Text(status),
                            selected: _selectedStatus == status,
                            onSelected: (selected) {
                              setState(() => _selectedStatus = status);
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppTheme.successColor.withValues(
                              alpha: 0.2,
                            ),
                            checkmarkColor: AppTheme.successColor,
                            labelStyle: AppTheme.bodySmall.copyWith(
                              color: _selectedStatus == status
                                  ? AppTheme.successColor
                                  : AppTheme.textSecondary,
                              fontWeight: _selectedStatus == status
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: _selectedStatus == status
                                  ? AppTheme.successColor
                                  : AppTheme.textSecondary.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsDashboard() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: AppTheme.adminColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'إحصائيات المحتوى',
                style: AppTheme.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'إجمالي المقالات',
                  '156',
                  '+12%',
                  Icons.article,
                  AppTheme.primaryColor,
                  true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticsCard(
                  'إجمالي الفيديوهات',
                  '89',
                  '+8%',
                  Icons.video_library,
                  AppTheme.successColor,
                  true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'إجمالي الاختبارات',
                  '45',
                  '+15%',
                  Icons.quiz,
                  AppTheme.warningColor,
                  true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalyticsCard(
                  'إجمالي المشاهدات',
                  '12.5K',
                  '+23%',
                  Icons.visibility,
                  AppTheme.adminColor,
                  true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.successColor.withValues(alpha: 0.1)
                      : AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: AppTheme.bodySmall.copyWith(
                    color: isPositive
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
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
        labelStyle: AppTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.article), text: 'المقالات'),
          Tab(icon: Icon(Icons.video_library), text: 'الفيديوهات'),
          Tab(icon: Icon(Icons.quiz), text: 'الاختبارات'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildArticlesTab();
      case 1:
        return _buildVideosTab();
      case 2:
        return _buildQuizzesTab();
      default:
        return _buildArticlesTab();
    }
  }

  Widget _buildArticlesTab() {
    final articles = _getFilteredArticles();

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المقالات (${articles.length})',
            style: AppTheme.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'البحث: "$_searchQuery" | الفئة: $_selectedCategory | الحالة: $_selectedStatus',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (articles.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'لا توجد مقالات مطابقة للفلترة',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...articles.map((article) => _buildArticleCard(article)),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    final videos = _getFilteredVideos();

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفيديوهات (${videos.length})',
            style: AppTheme.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'البحث: "$_searchQuery" | الفئة: $_selectedCategory | الحالة: $_selectedStatus',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (videos.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'لا توجد فيديوهات مطابقة للفلترة',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...videos.map((video) => _buildVideoCard(video)),
        ],
      ),
    );
  }

  Widget _buildQuizzesTab() {
    final quizzes = _getFilteredQuizzes();

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الاختبارات (${quizzes.length})',
            style: AppTheme.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'البحث: "$_searchQuery" | الفئة: $_selectedCategory | الحالة: $_selectedStatus',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (quizzes.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'لا توجد اختبارات مطابقة للفلترة',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...quizzes.map((quiz) => _buildQuizCard(quiz)),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateContentDialog(),
      backgroundColor: AppTheme.adminColor,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        'إضافة محتوى',
        style: AppTheme.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Helper methods for filtering content
  List<Map<String, dynamic>> _getFilteredArticles() {
    final articles = [
      {
        'id': '1',
        'title': 'تمارين تقوية العضلات للمبتدئين',
        'author': 'د. أحمد محمد',
        'category': 'التمارين',
        'status': 'منشور',
        'publishDate': '2024-01-10',
        'views': 1250,
        'likes': 89,
        'comments': 23,
      },
      {
        'id': '2',
        'title': 'التغذية السليمة لذوي الإعاقة الحركية',
        'author': 'د. سارة أحمد',
        'category': 'التغذية',
        'status': 'في المراجعة',
        'publishDate': '2024-01-08',
        'views': 890,
        'likes': 67,
        'comments': 15,
      },
      {
        'id': '3',
        'title': 'كيفية التعامل مع الألم المزمن',
        'author': 'د. محمد علي',
        'category': 'العلاج الطبيعي',
        'status': 'منشور',
        'publishDate': '2024-01-05',
        'views': 2100,
        'likes': 156,
        'comments': 42,
      },
      {
        'id': '4',
        'title': 'تقنيات الاسترخاء والتأمل',
        'author': 'د. فاطمة حسن',
        'category': 'الدعم النفسي',
        'status': 'مسودة',
        'publishDate': '2024-01-12',
        'views': 0,
        'likes': 0,
        'comments': 0,
      },
    ];

    return articles.where((article) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          article['title'].toString().contains(_searchQuery) ||
          article['author'].toString().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'الكل' ||
          article['category'] == _selectedCategory;
      final matchesStatus =
          _selectedStatus == 'الكل' || article['status'] == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  List<Map<String, dynamic>> _getFilteredVideos() {
    final videos = [
      {
        'id': '1',
        'title': 'تمارين تقوية الظهر',
        'instructor': 'د. أحمد محمد',
        'category': 'التمارين',
        'status': 'منشور',
        'duration': '15 دقيقة',
        'views': 3200,
        'likes': 245,
        'uploadDate': '2024-01-09',
      },
      {
        'id': '2',
        'title': 'نصائح التغذية الصحية',
        'instructor': 'د. سارة أحمد',
        'category': 'التغذية',
        'status': 'منشور',
        'duration': '20 دقيقة',
        'views': 1850,
        'likes': 134,
        'uploadDate': '2024-01-07',
      },
      {
        'id': '3',
        'title': 'تقنيات الاسترخاء',
        'instructor': 'د. محمد علي',
        'category': 'الدعم النفسي',
        'status': 'في المراجعة',
        'duration': '12 دقيقة',
        'views': 0,
        'likes': 0,
        'uploadDate': '2024-01-11',
      },
    ];

    return videos.where((video) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          video['title'].toString().contains(_searchQuery) ||
          video['instructor'].toString().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'الكل' || video['category'] == _selectedCategory;
      final matchesStatus =
          _selectedStatus == 'الكل' || video['status'] == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  List<Map<String, dynamic>> _getFilteredQuizzes() {
    final quizzes = [
      {
        'id': '1',
        'title': 'أساسيات العلاج الطبيعي',
        'category': 'العلاج الطبيعي',
        'status': 'منشور',
        'questions': 15,
        'duration': '10 دقائق',
        'attempts': 456,
        'averageScore': 78.5,
        'createDate': '2024-01-06',
      },
      {
        'id': '2',
        'title': 'التغذية الصحية',
        'category': 'التغذية',
        'status': 'منشور',
        'questions': 12,
        'duration': '8 دقائق',
        'attempts': 289,
        'averageScore': 82.3,
        'createDate': '2024-01-04',
      },
      {
        'id': '3',
        'title': 'الصحة النفسية',
        'category': 'الدعم النفسي',
        'status': 'مسودة',
        'questions': 20,
        'duration': '15 دقيقة',
        'attempts': 0,
        'averageScore': 0,
        'createDate': '2024-01-13',
      },
    ];

    return quizzes.where((quiz) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          quiz['title'].toString().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'الكل' || quiz['category'] == _selectedCategory;
      final matchesStatus =
          _selectedStatus == 'الكل' || quiz['status'] == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  // Content Card Builders
  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    article['status'],
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  article['status'],
                  style: AppTheme.bodySmall.copyWith(
                    color: _getStatusColor(article['status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) => _handleArticleAction(value, article),
                icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  const PopupMenuItem(value: 'publish', child: Text('نشر')),
                  const PopupMenuItem(value: 'archive', child: Text('أرشفة')),
                  const PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article['title'],
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'بواسطة ${article['author']}',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.adminColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  article['category'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.adminColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text('${article['views']}', style: AppTheme.bodySmall),
                  const SizedBox(width: 12),
                  Icon(Icons.favorite, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text('${article['likes']}', style: AppTheme.bodySmall),
                  const SizedBox(width: 12),
                  Icon(Icons.comment, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text('${article['comments']}', style: AppTheme.bodySmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    video['status'],
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  video['status'],
                  style: AppTheme.bodySmall.copyWith(
                    color: _getStatusColor(video['status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) => _handleVideoAction(value, video),
                icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  const PopupMenuItem(value: 'publish', child: Text('نشر')),
                  const PopupMenuItem(value: 'archive', child: Text('أرشفة')),
                  const PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.adminColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.play_circle_filled,
                  color: AppTheme.adminColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'],
                      style: AppTheme.titleSmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'بواسطة ${video['instructor']}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(video['duration'], style: AppTheme.bodySmall),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text('${video['views']}', style: AppTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(quiz['status']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quiz['status'],
                  style: AppTheme.bodySmall.copyWith(
                    color: _getStatusColor(quiz['status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) => _handleQuizAction(value, quiz),
                icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  const PopupMenuItem(value: 'publish', child: Text('نشر')),
                  const PopupMenuItem(value: 'archive', child: Text('أرشفة')),
                  const PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quiz['title'],
            style: AppTheme.titleSmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.adminColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  quiz['category'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.adminColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.quiz, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text('${quiz['questions']} سؤال', style: AppTheme.bodySmall),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(quiz['duration'], style: AppTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('المحاولات: ${quiz['attempts']}', style: AppTheme.bodySmall),
              const SizedBox(width: 16),
              Text(
                'المتوسط: ${quiz['averageScore']}%',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'منشور':
        return AppTheme.successColor;
      case 'في المراجعة':
        return AppTheme.warningColor;
      case 'مسودة':
        return AppTheme.textSecondary;
      case 'مرفوض':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _handleArticleAction(String action, Map<String, dynamic> article) {
    switch (action) {
      case 'edit':
        _editArticle(article);
        break;
      case 'publish':
        _publishContent(article, 'مقال');
        break;
      case 'archive':
        _archiveContent(article, 'مقال');
        break;
      case 'delete':
        _deleteContent(article, 'مقال');
        break;
    }
  }

  void _handleVideoAction(String action, Map<String, dynamic> video) {
    switch (action) {
      case 'edit':
        _editVideo(video);
        break;
      case 'publish':
        _publishContent(video, 'فيديو');
        break;
      case 'archive':
        _archiveContent(video, 'فيديو');
        break;
      case 'delete':
        _deleteContent(video, 'فيديو');
        break;
    }
  }

  void _handleQuizAction(String action, Map<String, dynamic> quiz) {
    switch (action) {
      case 'edit':
        _editQuiz(quiz);
        break;
      case 'publish':
        _publishContent(quiz, 'اختبار');
        break;
      case 'archive':
        _archiveContent(quiz, 'اختبار');
        break;
      case 'delete':
        _deleteContent(quiz, 'اختبار');
        break;
    }
  }

  // Action Methods
  void _editArticle(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المقال'),
        content: Text('تعديل المقال: ${article['title']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات')));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _editVideo(Map<String, dynamic> video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الفيديو'),
        content: Text('تعديل الفيديو: ${video['title']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات')));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _editQuiz(Map<String, dynamic> quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الاختبار'),
        content: Text('تعديل الاختبار: ${quiz['title']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات')));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _publishContent(Map<String, dynamic> content, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('نشر $type'),
        content: Text('هل تريد نشر $type: ${content['title']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم نشر $type بنجاح')));
            },
            child: const Text('نشر'),
          ),
        ],
      ),
    );
  }

  void _archiveContent(Map<String, dynamic> content, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('أرشفة $type'),
        content: Text('هل تريد أرشفة $type: ${content['title']}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم أرشفة $type')));
            },
            child: const Text('أرشفة'),
          ),
        ],
      ),
    );
  }

  void _deleteContent(Map<String, dynamic> content, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف $type'),
        content: Text(
          'هل تريد حذف $type: ${content['title']}؟\nهذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم حذف $type')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showCreateContentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة محتوى جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.article, color: AppTheme.adminColor),
              title: const Text('مقال جديد'),
              onTap: () {
                Navigator.pop(context);
                _createNewArticle();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.video_library,
                color: AppTheme.adminColor,
              ),
              title: const Text('فيديو جديد'),
              onTap: () {
                Navigator.pop(context);
                _createNewVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: AppTheme.adminColor),
              title: const Text('اختبار جديد'),
              onTap: () {
                Navigator.pop(context);
                _createNewQuiz();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createNewArticle() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('فتح محرر المقالات الجديد')));
  }

  void _createNewVideo() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('فتح محرر الفيديوهات الجديد')));
  }

  void _createNewQuiz() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('فتح محرر الاختبارات الجديد')));
  }

  void _showNotifications() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('عرض الإشعارات')));
  }

  void _showSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('فتح الإعدادات')));
  }
}
