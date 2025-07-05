import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/performance_utils.dart';

class MedicalStoreScreen extends StatefulWidget {
  const MedicalStoreScreen({super.key});

  @override
  State<MedicalStoreScreen> createState() => _MedicalStoreScreenState();
}

class _MedicalStoreScreenState extends State<MedicalStoreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _cartItems = [];
  final int _selectedCategoryIndex = 0;

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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('المتجر الطبي'),
        backgroundColor: AppTheme.patientColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCart(),
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.store), text: 'محلات المستلزمات الطبية'),
            Tab(icon: Icon(Icons.extension), text: 'طلبات الأعضاء واللواحق'),
            Tab(icon: Icon(Icons.health_and_safety), text: 'مستلزمات العناية'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildShopsTab(),
              _buildRequestsTab(),
              _buildCareSuppliesTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopsTab() {
    final shops = [
      {
        'name': 'محل الحياة للمستلزمات الطبية',
        'address': 'سطيف - شارع الاستقلال',
        'services': ['بيع كراسي متحركة', 'أجهزة تعويضية', 'لواحق صناعية'],
        'products': ['كرسي متحرك كهربائي', 'طرف صناعي سفلي', 'عكاز طبي'],
        'phone': '+213 36 12 34 56',
      },
      {
        'name': 'مؤسسة الأمل للأجهزة الطبية',
        'address': 'سطيف - حي الهضاب',
        'services': ['تصنيع أطراف صناعية', 'صيانة أجهزة طبية'],
        'products': ['طرف علوي صناعي', 'جبيرة يد', 'دعامة ظهر'],
        'phone': '+213 36 23 45 67',
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop['name'] as String, style: AppTheme.titleLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(shop['address'] as String, style: AppTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('الخدمات:', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                ...List.generate((shop['services'] as List).length, (i) => Text('- ${(shop['services'] as List)[i] as String}', style: AppTheme.bodySmall)),
                const SizedBox(height: 8),
                Text('المنتجات المتوفرة:', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                ...List.generate((shop['products'] as List).length, (i) => Text('- ${(shop['products'] as List)[i] as String}', style: AppTheme.bodySmall)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16),
                    const SizedBox(width: 4),
                    Text(shop['phone'] as String, style: AppTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestsTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('طلب عضو أو لواحق صناعية', style: AppTheme.titleLarge.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('يمكنك هنا تقديم طلب للحصول على طرف صناعي أو لواحق طبية خاصة بك، وسيتم التواصل معك من قبل المحلات المختصة.'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: فتح نموذج الطلب
            },
            icon: const Icon(Icons.add),
            label: const Text('طلب جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.patientColor,
              foregroundColor: Colors.white,
            ),
          ),
          // يمكن إضافة قائمة الطلبات السابقة هنا لاحقاً
        ],
      ),
    );
  }

  Widget _buildCareSuppliesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeaturedSupply(),
          const SizedBox(height: 24),
          _buildSupplyCategories(),
          const SizedBox(height: 24),
          _buildPopularSupplies(),
        ],
      ),
    );
  }

  // Featured Supply Widget
  Widget _buildFeaturedSupply() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.purple.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'منتج مميز',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    Text(
                      'كرسي متحرك كهربائي',
                      style: AppTheme.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'كرسي متحرك كهربائي متطور مع تحكم ذكي وبطارية طويلة المدى.',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.battery_charging_full,
                color: Colors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'بطارية 8 ساعات',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _viewProduct('electric-wheelchair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                ),
                child: const Text('عرض التفاصيل'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Supply Categories Widget
  Widget _buildSupplyCategories() {
    final categories = [
      {'name': 'كراسي متحركة', 'icon': Icons.accessible, 'count': 10},
      {'name': 'عكازات ومشايات', 'icon': Icons.accessibility_new, 'count': 25},
      {'name': 'أسرة طبية', 'icon': Icons.bed, 'count': 8},
      {'name': 'مستلزمات الحمام', 'icon': Icons.bathtub, 'count': 15},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تصنيفات مستلزمات العناية',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        PerformanceUtils.buildOptimizedGridView(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category, Colors.purple);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  // Popular Supplies Widget
  Widget _buildPopularSupplies() {
    final supplies = [
      {
        'name': 'كرسي متحرك يدوي',
        'description': 'كرسي متحرك خفيف الوزن وقابل للطي',
        'price': 1200.00,
        'originalPrice': 1500.00,
        'rating': 4.7,
        'inStock': true,
        'image': 'assets/images/supply1.jpg',
      },
      {
        'name': 'عكاز طبي قابل للتعديل',
        'description': 'عكاز بارتفاع قابل للتعديل مع قبضة مريحة',
        'price': 85.00,
        'originalPrice': null,
        'rating': 4.4,
        'inStock': true,
        'image': 'assets/images/supply2.jpg',
      },
      {
        'name': 'مشاية طبية بعجلات',
        'description': 'مشاية خفيفة مع فرامل أمان',
        'price': 320.00,
        'originalPrice': 380.00,
        'rating': 4.6,
        'inStock': false,
        'image': 'assets/images/supply3.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مستلزمات العناية الأكثر طلباً',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...supplies.map((supply) => _buildSupplyCard(supply)),
      ],
    );
  }

  Widget _buildSupplyCard(Map<String, dynamic> supply) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: Colors.purple,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supply['name'],
                  style: AppTheme.titleSmall.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  supply['description'],
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRating(supply['rating']),
                    const Spacer(),
                    if (!supply['inStock'])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'غير متوفر',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${supply['price']} دج',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (supply['originalPrice'] != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${supply['originalPrice']} دج',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: supply['inStock'] ? () => _addToCart(supply) : null,
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: supply['inStock'] ? Colors.purple : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () => _addToWishlist(supply),
                icon: Icon(
                  Icons.favorite_border,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في المتجر'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement search functionality
            },
            child: const Text('بحث'),
          ),
        ],
      ),
    );
  }

  void _showCart() {
    // TODO: Show shopping cart
  }

  void _viewProduct(String productId) {
    // TODO: Navigate to product details
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${product['name']} إلى السلة'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addToWishlist(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${product['name']} إلى المفضلة'),
        backgroundColor: AppTheme.patientColor,
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star
                : index < rating
                ? Icons.star_half
                : Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category['icon'] as IconData, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            category['name'] as String,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '${category['count']} منتج',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
