import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_theme.dart';

class NearbyCentersScreen extends StatefulWidget {
  const NearbyCentersScreen({super.key});

  @override
  State<NearbyCentersScreen> createState() => _NearbyCentersScreenState();
}

class _NearbyCentersScreenState extends State<NearbyCentersScreen>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _isMapReady = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _locationPermissionDenied = false;

  final Set<Marker> _markers = {};
  final List<Map<String, dynamic>> _centers = [
    {
      'id': '1',
      'name': 'مركز سطيف للعلاج الطبيعي والتأهيل',
      'specialty': 'العلاج الطبيعي والتأهيل الحركي',
      'address': 'شارع الاستقلال، سطيف',
      'phone': '+213551234567',
      'rating': 4.8,
      'distance': '2.5 كم',
      'lat': 36.1919,
      'lng': 5.4133,
      'workingHours': '8:00 ص - 10:00 م',
      'services': ['علاج طبيعي', 'تأهيل حركي', 'علاج وظيفي', 'إرشاد نفسي'],
    },
    {
      'id': '2',
      'name': 'مستشفى سطيف الجامعي',
      'specialty': 'طب العظام والأطراف الاصطناعية',
      'address': 'حي الجامعة، سطيف',
      'phone': '+213551234568',
      'rating': 4.9,
      'distance': '3.2 كم',
      'lat': 36.2019,
      'lng': 5.4233,
      'workingHours': '24 ساعة',
      'services': ['جراحة العظام', 'تصنيع الأطراف الاصطناعية', 'تأهيل حركي'],
    },
    {
      'id': '3',
      'name': 'مركز الأمل للتأهيل والإرشاد',
      'specialty': 'التأهيل والإرشاد الاجتماعي',
      'address': 'شارع الثورة، سطيف',
      'phone': '+213551234569',
      'rating': 4.7,
      'distance': '1.8 كم',
      'lat': 36.1819,
      'lng': 5.4033,
      'workingHours': '7:00 ص - 9:00 م',
      'services': ['إرشاد اجتماعي', 'إرشاد نفسي', 'تأهيل حركي', 'دعم أسري'],
    },
    {
      'id': '4',
      'name': 'عيادة الدكتور محمد للعظام والأطراف الاصطناعية',
      'specialty': 'طب العظام وتصنيع الأطراف',
      'address': 'حي السلام، سطيف',
      'phone': '+213551234570',
      'rating': 4.6,
      'distance': '4.1 كم',
      'lat': 36.1719,
      'lng': 5.4333,
      'workingHours': '9:00 ص - 8:00 م',
      'services': ['جراحة العظام', 'تصنيع الأطراف الاصطناعية', 'تأهيل حركي'],
    },
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

    _getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      final permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        setState(() {
          _locationPermissionDenied = true;
        });
        _showPermissionDialog();
        return;
      } else {
        setState(() {
          _locationPermissionDenied = false;
        });
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _createMarkers();
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('حدث خطأ في تحديد الموقع: ${e.toString()}');
    }
  }

  void _createMarkers() {
    _markers.clear();

    // Add current location marker
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'موقعي الحالي',
            snippet: 'أنت هنا',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add center markers
    for (var center in _centers) {
      _markers.add(
        Marker(
          markerId: MarkerId(center['id']),
          position: LatLng(center['lat'], center['lng']),
          infoWindow: InfoWindow(
            title: center['name'],
            snippet: '${center['specialty']} - ${center['distance']}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () => _showCenterDetails(center),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });

    // Move camera to current location if available
    if (_currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14.0,
        ),
      );
    }
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCenterDetailsSheet(center),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('المراكز القريبة'),
        backgroundColor: AppTheme.patientColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
          IconButton(icon: const Icon(Icons.list), onPressed: _showCentersList),
        ],
      ),
      body: _locationPermissionDenied
          ? _buildLocationPermissionWidget()
          : _isLoading
              ? _buildLoadingWidget()
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: Stack(
                    children: [_buildMap(), _buildSearchBar(), _buildFilterChips()],
                  ),
                ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.patientColor),
          const SizedBox(height: 16),
          Text(
            'جاري تحديد موقعك...',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(36.1919, 5.4133), // Default to Setif, Algeria
        zoom: 14.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
      buildingsEnabled: true,
      trafficEnabled: false,
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'البحث عن مركز طبي...',
            prefixIcon: Icon(Icons.search, color: AppTheme.patientColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
          onChanged: (value) {
            // TODO: Implement search functionality
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      'الكل',
      'العلاج الطبيعي',
      'طب العظام',
      'التأهيل الطبي',
      'طب متخصص',
    ];

    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final isSelected = index == 0; // Default to "الكل"
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filters[index]),
                selected: isSelected,
                onSelected: (selected) {
                  // TODO: Implement filter functionality
                },
                backgroundColor: Colors.white,
                selectedColor: AppTheme.patientColor.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppTheme.patientColor
                      : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.patientColor : Colors.grey[300]!,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCenterDetailsSheet(Map<String, dynamic> center) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center name and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              center['name'],
                              style: AppTheme.headlineSmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              center['specialty'],
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.patientColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              center['rating'].toString(),
                              style: AppTheme.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Contact information
                  _buildInfoRow(Icons.location_on, center['address']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, center['phone']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.access_time, center['workingHours']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.directions, center['distance']),

                  const SizedBox(height: 24),

                  // Services
                  Text(
                    'الخدمات المتاحة',
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (center['services'] as List<String>).map((
                      service,
                    ) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.patientColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppTheme.patientColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          service,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.patientColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _callCenter(center['phone']),
                          icon: const Icon(Icons.phone),
                          label: const Text('اتصال'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _getDirections(center),
                          icon: const Icon(Icons.directions),
                          label: const Text('الاتجاهات'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.patientColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.patientColor, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTheme.bodyMedium)),
      ],
    );
  }

  void _showCentersList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'قائمة المراكز',
                    style: AppTheme.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_centers.length} مركز',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Centers list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _centers.length,
                itemBuilder: (context, index) {
                  final center = _centers[index];
                  return _buildCenterCard(center);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCard(Map<String, dynamic> center) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showCenterDetails(center);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          center['name'],
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          center['specialty'],
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.patientColor,
                            fontWeight: FontWeight.w600,
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
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          center['rating'].toString(),
                          style: AppTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
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
                  Icon(
                    Icons.location_on,
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      center['address'],
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    center['distance'],
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.patientColor,
                      fontWeight: FontWeight.w600,
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

  void _callCenter(String phoneNumber) {
    // TODO: Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم الاتصال بـ $phoneNumber'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _getDirections(Map<String, dynamic> center) {
    // TODO: Implement directions functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم فتح الاتجاهات إلى ${center['name']}'),
        backgroundColor: AppTheme.patientColor,
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إذن الموقع مطلوب'),
        content: const Text('لا يمكن عرض المراكز القريبة بدون تفعيل إذن الموقع. يرجى السماح للتطبيق بالوصول إلى موقعك من إعدادات الجهاز.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خدمة الموقع غير مفعلة'),
        content: const Text(
          'يرجى تفعيل خدمة الموقع في إعدادات الجهاز لإظهار المراكز القريبة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocation();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPermissionWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 60, color: Colors.red[300]),
            const SizedBox(height: 24),
            Text(
              'يحتاج التطبيق إلى إذن الوصول إلى الموقع لعرض المراكز القريبة منك.',
              style: AppTheme.headlineSmall.copyWith(color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى تفعيل إذن الموقع من إعدادات الجهاز أو الضغط على الزر بالأسفل.',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('تفعيل الموقع'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.patientColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
