import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/performance_utils.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _availableSlots = [];
  String _selectedFilter = 'الكل';

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
    _loadScheduleData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadScheduleData() {
    // Sample appointments data
    _appointments = [
      {
        'id': '1',
        'patientName': 'أحمد محمد',
        'patientAge': 35,
        'appointmentType': 'استشارة عامة',
        'date': DateTime.now().add(const Duration(hours: 2)),
        'duration': 30,
        'status': 'مؤكد',
        'priority': 'عادية',
        'notes': 'مراجعة دورية',
      },
      {
        'id': '2',
        'patientName': 'فاطمة علي',
        'patientAge': 28,
        'appointmentType': 'متابعة علاج',
        'date': DateTime.now().add(const Duration(hours: 4)),
        'duration': 45,
        'status': 'في الانتظار',
        'priority': 'عالية',
        'notes': 'متابعة نتائج التحاليل',
      },
      {
        'id': '3',
        'patientName': 'محمد سالم',
        'patientAge': 42,
        'appointmentType': 'استشارة طارئة',
        'date': DateTime.now().add(const Duration(hours: 6)),
        'duration': 60,
        'status': 'مؤكد',
        'priority': 'عالية',
        'notes': 'ألم شديد في الصدر',
      },
    ];

    // Sample available slots
    _availableSlots = [
      {
        'id': '1',
        'date': DateTime.now().add(const Duration(days: 1)),
        'startTime': const TimeOfDay(hour: 9, minute: 0),
        'endTime': const TimeOfDay(hour: 10, minute: 0),
        'isBooked': false,
      },
      {
        'id': '2',
        'date': DateTime.now().add(const Duration(days: 1)),
        'startTime': const TimeOfDay(hour: 10, minute: 30),
        'endTime': const TimeOfDay(hour: 11, minute: 30),
        'isBooked': false,
      },
      {
        'id': '3',
        'date': DateTime.now().add(const Duration(days: 2)),
        'startTime': const TimeOfDay(hour: 14, minute: 0),
        'endTime': const TimeOfDay(hour: 15, minute: 0),
        'isBooked': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('إدارة الجدولة'),
          backgroundColor: AppTheme.doctorColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addAvailableSlot,
            ),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'export_schedule',
                  child: Text('تصدير الجدول'),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('إعدادات الجدولة'),
                ),
              ],
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildFilterTabs(),
                Expanded(child: _buildScheduleContent()),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addAvailableSlot,
          backgroundColor: AppTheme.doctorColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['الكل', 'اليوم', 'غداً', 'هذا الأسبوع', 'المتاحة'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.doctorColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.doctorColor
                        : Colors.grey.shade300,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.doctorColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScheduleContent() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppTheme.doctorColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.doctorColor,
            tabs: const [
              Tab(text: 'المواعيد المحجوزة'),
              Tab(text: 'الأوقات المتاحة'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [_buildAppointmentsList(), _buildAvailableSlotsList()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final filteredAppointments = _getFilteredAppointments();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'لا توجد مواعيد',
              style: AppTheme.titleLarge.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return PerformanceUtils.buildOptimizedListView(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _buildAppointmentCard(appointment);
      },
      padding: const EdgeInsets.all(16),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment['patientName'],
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      appointment['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    appointment['status'],
                    style: AppTheme.bodySmall.copyWith(
                      color: _getStatusColor(appointment['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.medical_services,
                  color: AppTheme.doctorColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment['appointmentType'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.doctorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(appointment['date']),
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.timer, color: AppTheme.textSecondary, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${appointment['duration']} دقيقة',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            if (appointment['notes'] != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, color: AppTheme.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment['notes'],
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _rescheduleAppointment(appointment),
                  icon: const Icon(Icons.schedule, size: 16),
                  label: const Text('إعادة جدولة'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.doctorColor,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _viewAppointmentDetails(appointment),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('التفاصيل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.doctorColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableSlotsList() {
    if (_availableSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'لا توجد أوقات متاحة',
              style: AppTheme.titleLarge.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addAvailableSlot,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.doctorColor,
              ),
              child: const Text('إضافة وقت متاح'),
            ),
          ],
        ),
      );
    }

    return PerformanceUtils.buildOptimizedListView(
      itemCount: _availableSlots.length,
      itemBuilder: (context, index) {
        final slot = _availableSlots[index];
        return _buildAvailableSlotCard(slot);
      },
      padding: const EdgeInsets.all(16),
    );
  }

  Widget _buildAvailableSlotCard(Map<String, dynamic> slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: slot['isBooked']
              ? Colors.grey.shade300
              : AppTheme.doctorColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(slot['date']),
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: slot['isBooked']
                        ? Colors.grey.shade100
                        : AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slot['isBooked'] ? 'محجوز' : 'متاح',
                    style: AppTheme.bodySmall.copyWith(
                      color: slot['isBooked']
                          ? Colors.grey.shade600
                          : AppTheme.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.doctorColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_formatTime(slot['startTime'])} - ${_formatTime(slot['endTime'])}',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!slot['isBooked']) ...[
                  TextButton.icon(
                    onPressed: () => _editAvailableSlot(slot),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('تعديل'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.doctorColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _deleteAvailableSlot(slot),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('حذف'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  List<Map<String, dynamic>> _getFilteredAppointments() {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'اليوم':
        return _appointments.where((appointment) {
          final appointmentDate = appointment['date'] as DateTime;
          return appointmentDate.day == now.day &&
              appointmentDate.month == now.month &&
              appointmentDate.year == now.year;
        }).toList();
      case 'غداً':
        final tomorrow = now.add(const Duration(days: 1));
        return _appointments.where((appointment) {
          final appointmentDate = appointment['date'] as DateTime;
          return appointmentDate.day == tomorrow.day &&
              appointmentDate.month == tomorrow.month &&
              appointmentDate.year == tomorrow.year;
        }).toList();
      case 'هذا الأسبوع':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return _appointments.where((appointment) {
          final appointmentDate = appointment['date'] as DateTime;
          return appointmentDate.isAfter(weekStart) &&
              appointmentDate.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
      default:
        return _appointments;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مؤكد':
        return AppTheme.successColor;
      case 'في الانتظار':
        return AppTheme.warningColor;
      case 'ملغي':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'اليوم ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
    } else if (difference.inDays == -1) {
      return 'غداً ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${_formatTime(TimeOfDay.fromDateTime(dateTime))}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == -1) {
      return 'غداً';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Action methods
  void _addAvailableSlot() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
        TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
        TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('إضافة وقت متاح'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('التاريخ'),
                      subtitle: Text(_formatDate(selectedDate)),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          setState(() => selectedDate = date);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('وقت البداية'),
                      subtitle: Text(_formatTime(startTime)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setState(() => startTime = time);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.access_time_filled,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('وقت النهاية'),
                      subtitle: Text(_formatTime(endTime)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setState(() => endTime = time);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newSlot = {
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'date': selectedDate,
                      'startTime': startTime,
                      'endTime': endTime,
                      'isBooked': false,
                    };

                    this.setState(() {
                      _availableSlots.add(newSlot);
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم إضافة الوقت المتاح بنجاح'),
                        backgroundColor: AppTheme.successColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.doctorColor,
                  ),
                  child: const Text('إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editAvailableSlot(Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDate = slot['date'];
        TimeOfDay startTime = slot['startTime'];
        TimeOfDay endTime = slot['endTime'];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('تعديل الوقت المتاح'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('التاريخ'),
                      subtitle: Text(_formatDate(selectedDate)),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          setState(() => selectedDate = date);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('وقت البداية'),
                      subtitle: Text(_formatTime(startTime)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setState(() => startTime = time);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.access_time_filled,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('وقت النهاية'),
                      subtitle: Text(_formatTime(endTime)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setState(() => endTime = time);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.setState(() {
                      slot['date'] = selectedDate;
                      slot['startTime'] = startTime;
                      slot['endTime'] = endTime;
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم تعديل الوقت المتاح بنجاح'),
                        backgroundColor: AppTheme.successColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.doctorColor,
                  ),
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteAvailableSlot(Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف الوقت المتاح'),
          content: const Text('هل أنت متأكد من حذف هذا الوقت المتاح؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _availableSlots.remove(slot);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم حذف الوقت المتاح'),
                    backgroundColor: AppTheme.errorColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  void _rescheduleAppointment(Map<String, dynamic> appointment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('إعادة جدولة موعد ${appointment['patientName']}'),
        backgroundColor: AppTheme.doctorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _viewAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تفاصيل موعد ${appointment['patientName']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('اسم المريض', appointment['patientName']),
                _buildDetailRow('العمر', '${appointment['patientAge']} سنة'),
                _buildDetailRow(
                  'نوع الاستشارة',
                  appointment['appointmentType'],
                ),
                _buildDetailRow(
                  'التاريخ والوقت',
                  _formatDateTime(appointment['date']),
                ),
                _buildDetailRow('المدة', '${appointment['duration']} دقيقة'),
                _buildDetailRow('الحالة', appointment['status']),
                _buildDetailRow('الأولوية', appointment['priority']),
                if (appointment['notes'] != null)
                  _buildDetailRow('ملاحظات', appointment['notes']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/doctor/chat',
                  arguments: {
                    'patientId': appointment['id'],
                    'patientName': appointment['patientName'],
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.doctorColor,
              ),
              child: const Text('بدء المحادثة'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_schedule':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم إضافة ميزة تصدير الجدول قريباً')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم إضافة إعدادات الجدولة قريباً')),
        );
        break;
    }
  }
}
