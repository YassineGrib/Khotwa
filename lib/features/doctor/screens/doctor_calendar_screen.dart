import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';

class DoctorCalendarScreen extends StatefulWidget {
  const DoctorCalendarScreen({super.key});

  @override
  State<DoctorCalendarScreen> createState() => _DoctorCalendarScreenState();
}

class _DoctorCalendarScreenState extends State<DoctorCalendarScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  List<Map<String, dynamic>> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
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
    _loadCalendarEvents();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadCalendarEvents() {
    // Sample events data
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));

    _events = {
      today: [
        {
          'id': '1',
          'title': 'استشارة أحمد محمد',
          'time': '09:00',
          'duration': 30,
          'type': 'appointment',
          'status': 'confirmed',
          'patientName': 'أحمد محمد',
          'description': 'مراجعة دورية',
        },
        {
          'id': '2',
          'title': 'متابعة فاطمة علي',
          'time': '11:30',
          'duration': 45,
          'type': 'followup',
          'status': 'confirmed',
          'patientName': 'فاطمة علي',
          'description': 'متابعة نتائج التحاليل',
        },
        {
          'id': '3',
          'title': 'اجتماع فريق طبي',
          'time': '14:00',
          'duration': 60,
          'type': 'meeting',
          'status': 'confirmed',
          'description': 'مناقشة الحالات المعقدة',
        },
      ],
      tomorrow: [
        {
          'id': '4',
          'title': 'استشارة محمد سالم',
          'time': '10:00',
          'duration': 30,
          'type': 'appointment',
          'status': 'pending',
          'patientName': 'محمد سالم',
          'description': 'استشارة جديدة',
        },
        {
          'id': '5',
          'title': 'ورشة تدريبية',
          'time': '15:00',
          'duration': 120,
          'type': 'training',
          'status': 'confirmed',
          'description': 'تدريب على التقنيات الحديثة',
        },
      ],
      dayAfterTomorrow: [
        {
          'id': '6',
          'title': 'استشارة عائلة الأحمد',
          'time': '09:30',
          'duration': 60,
          'type': 'family_consultation',
          'status': 'confirmed',
          'patientName': 'عائلة الأحمد',
          'description': 'استشارة عائلية شاملة',
        },
      ],
    };

    _selectedEvents = _getEventsForDay(_selectedDay!);
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('التقويم الطبي'),
          backgroundColor: AppTheme.doctorColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.today), onPressed: _goToToday),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'add_event',
                  child: Text('إضافة حدث'),
                ),
                const PopupMenuItem(
                  value: 'view_week',
                  child: Text('عرض أسبوعي'),
                ),
                const PopupMenuItem(
                  value: 'export_calendar',
                  child: Text('تصدير التقويم'),
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
                _buildCalendar(),
                const SizedBox(height: 8),
                Expanded(child: _buildEventsList()),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addEvent,
          backgroundColor: AppTheme.doctorColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: TableCalendar<Map<String, dynamic>>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.saturday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: AppTheme.errorColor),
          holidayTextStyle: TextStyle(color: AppTheme.errorColor),
          selectedDecoration: BoxDecoration(
            color: AppTheme.doctorColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.doctorColor.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: AppTheme.warningColor,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: AppTheme.doctorColor,
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: const TextStyle(color: Colors.white),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: AppTheme.doctorColor,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: AppTheme.doctorColor,
          ),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _selectedEvents = _getEventsForDay(selectedDay);
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'لا توجد أحداث في هذا اليوم',
              style: AppTheme.titleLarge.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.doctorColor,
              ),
              child: const Text('إضافة حدث'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أحداث ${_formatSelectedDate()}',
            style: AppTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _selectedEvents.length,
            itemBuilder: (context, index) {
              final event = _selectedEvents[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getEventTypeColor(event['type']).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
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
                    event['title'],
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      event['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(event['status']),
                    style: AppTheme.bodySmall.copyWith(
                      color: _getStatusColor(event['status']),
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
                  _getEventTypeIcon(event['type']),
                  color: _getEventTypeColor(event['type']),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _getEventTypeText(event['type']),
                  style: AppTheme.bodyMedium.copyWith(
                    color: _getEventTypeColor(event['type']),
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
                  '${event['time']} (${event['duration']} دقيقة)',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            if (event['description'] != null) ...[
              const SizedBox(height: 8),
              Text(
                event['description'],
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _editEvent(event),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('تعديل'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.doctorColor,
                  ),
                ),
                const SizedBox(width: 8),
                if (event['type'] == 'appointment' ||
                    event['type'] == 'followup')
                  ElevatedButton.icon(
                    onPressed: () => _startConsultation(event),
                    icon: const Icon(Icons.video_call, size: 16),
                    label: const Text('بدء الاستشارة'),
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

  // Helper methods
  Color _getEventTypeColor(String type) {
    switch (type) {
      case 'appointment':
        return AppTheme.doctorColor;
      case 'followup':
        return AppTheme.primaryColor;
      case 'meeting':
        return AppTheme.warningColor;
      case 'training':
        return AppTheme.primaryColor;
      case 'family_consultation':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getEventTypeIcon(String type) {
    switch (type) {
      case 'appointment':
        return Icons.medical_services;
      case 'followup':
        return Icons.follow_the_signs;
      case 'meeting':
        return Icons.group;
      case 'training':
        return Icons.school;
      case 'family_consultation':
        return Icons.family_restroom;
      default:
        return Icons.event;
    }
  }

  String _getEventTypeText(String type) {
    switch (type) {
      case 'appointment':
        return 'موعد استشارة';
      case 'followup':
        return 'متابعة';
      case 'meeting':
        return 'اجتماع';
      case 'training':
        return 'تدريب';
      case 'family_consultation':
        return 'استشارة عائلية';
      default:
        return 'حدث';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.warningColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'مؤكد';
      case 'pending':
        return 'في الانتظار';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير محدد';
    }
  }

  String _formatSelectedDate() {
    if (_selectedDay == null) return '';

    final now = DateTime.now();
    final selected = _selectedDay!;

    if (selected.day == now.day &&
        selected.month == now.month &&
        selected.year == now.year) {
      return 'اليوم';
    } else if (selected.day == now.add(const Duration(days: 1)).day &&
        selected.month == now.add(const Duration(days: 1)).month &&
        selected.year == now.add(const Duration(days: 1)).year) {
      return 'غداً';
    } else {
      return '${selected.day}/${selected.month}/${selected.year}';
    }
  }

  // Action methods
  void _goToToday() {
    setState(() {
      _selectedDay = DateTime.now();
      _focusedDay = DateTime.now();
      _selectedEvents = _getEventsForDay(_selectedDay!);
    });
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';
        String type = 'appointment';
        TimeOfDay time = TimeOfDay.now();
        int duration = 30;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('إضافة حدث جديد'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'عنوان الحدث',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => title = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: const InputDecoration(
                        labelText: 'نوع الحدث',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'appointment',
                          child: Text('موعد استشارة'),
                        ),
                        DropdownMenuItem(
                          value: 'followup',
                          child: Text('متابعة'),
                        ),
                        DropdownMenuItem(
                          value: 'meeting',
                          child: Text('اجتماع'),
                        ),
                        DropdownMenuItem(
                          value: 'training',
                          child: Text('تدريب'),
                        ),
                        DropdownMenuItem(
                          value: 'family_consultation',
                          child: Text('استشارة عائلية'),
                        ),
                      ],
                      onChanged: (value) => setState(() => type = value!),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: AppTheme.doctorColor,
                      ),
                      title: const Text('الوقت'),
                      subtitle: Text(
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      ),
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: time,
                        );
                        if (selectedTime != null) {
                          setState(() => time = selectedTime);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'المدة (بالدقائق)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          duration = int.tryParse(value) ?? 30,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'الوصف',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => description = value,
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
                    if (title.isNotEmpty) {
                      final newEvent = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'title': title,
                        'time':
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                        'duration': duration,
                        'type': type,
                        'status': 'confirmed',
                        'description': description.isNotEmpty
                            ? description
                            : null,
                      };

                      final selectedDate = DateTime(
                        _selectedDay!.year,
                        _selectedDay!.month,
                        _selectedDay!.day,
                      );

                      this.setState(() {
                        if (_events[selectedDate] == null) {
                          _events[selectedDate] = [];
                        }
                        _events[selectedDate]!.add(newEvent);
                        _selectedEvents = _getEventsForDay(_selectedDay!);
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('تم إضافة الحدث بنجاح'),
                          backgroundColor: AppTheme.successColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
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

  void _editEvent(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تعديل الحدث: ${event['title']}'),
        backgroundColor: AppTheme.doctorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _startConsultation(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('بدء الاستشارة'),
          content: Text(
            'هل تريد بدء الاستشارة مع ${event['patientName'] ?? 'المريض'}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/doctor/chat',
                  arguments: {
                    'patientId': event['id'],
                    'patientName': event['patientName'] ?? 'مريض',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.doctorColor,
              ),
              child: const Text('بدء الاستشارة'),
            ),
          ],
        );
      },
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'add_event':
        _addEvent();
        break;
      case 'view_week':
        setState(() {
          _calendarFormat = CalendarFormat.week;
        });
        break;
      case 'export_calendar':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم إضافة ميزة تصدير التقويم قريباً')),
        );
        break;
    }
  }
}
