import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DoctorConsultationsScreen extends StatefulWidget {
  const DoctorConsultationsScreen({super.key});

  @override
  State<DoctorConsultationsScreen> createState() =>
      _DoctorConsultationsScreenState();
}

class _DoctorConsultationsScreenState extends State<DoctorConsultationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late TabController _tabController;

  List<Map<String, dynamic>> _pendingConsultations = [];
  List<Map<String, dynamic>> _activeConsultations = [];
  List<Map<String, dynamic>> _completedConsultations = [];

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
    _tabController = TabController(length: 3, vsync: this);
    _animationController.forward();
    _loadConsultations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadConsultations() {
    // Sample data - will be replaced with actual API calls
    _pendingConsultations = [
      {
        'id': '1',
        'patientName': 'أحمد محمد',
        'patientAge': 35,
        'subject': 'ألم في الصدر',
        'description':
            'أعاني من ألم في الصدر منذ يومين، خاصة عند التنفس العميق',
        'priority': 'عالية',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'symptoms': ['ألم في الصدر', 'صعوبة في التنفس'],
        'medicalHistory': ['ضغط الدم المرتفع'],
      },
      {
        'id': '2',
        'patientName': 'فاطمة علي',
        'patientAge': 28,
        'subject': 'صداع مستمر',
        'description': 'صداع شديد مستمر منذ أسبوع مع غثيان',
        'priority': 'متوسطة',
        'date': DateTime.now().subtract(const Duration(hours: 5)),
        'symptoms': ['صداع', 'غثيان', 'حساسية للضوء'],
        'medicalHistory': ['لا يوجد'],
      },
    ];

    _activeConsultations = [
      {
        'id': '3',
        'patientName': 'محمد سالم',
        'patientAge': 42,
        'subject': 'متابعة علاج السكري',
        'description': 'متابعة دورية لعلاج السكري وتعديل الجرعات',
        'priority': 'متوسطة',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'قيد المتابعة',
        'lastUpdate': DateTime.now().subtract(const Duration(hours: 3)),
      },
    ];

    _completedConsultations = [
      {
        'id': '4',
        'patientName': 'سارة أحمد',
        'patientAge': 30,
        'subject': 'فحص دوري',
        'description': 'فحص دوري شامل',
        'priority': 'منخفضة',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'completedDate': DateTime.now().subtract(const Duration(days: 2)),
        'diagnosis': 'حالة صحية جيدة',
        'treatment': 'لا يوجد علاج مطلوب',
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
          title: const Text('إدارة الاستشارات'),
          backgroundColor: AppTheme.doctorColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            tabs: [
              Tab(
                icon: const Icon(Icons.pending_actions),
                text: 'معلقة (${_pendingConsultations.length})',
              ),
              Tab(
                icon: const Icon(Icons.medical_services),
                text: 'نشطة (${_activeConsultations.length})',
              ),
              Tab(
                icon: const Icon(Icons.check_circle),
                text: 'مكتملة (${_completedConsultations.length})',
              ),
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
                _buildPendingConsultations(),
                _buildActiveConsultations(),
                _buildCompletedConsultations(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingConsultations() {
    if (_pendingConsultations.isEmpty) {
      return _buildEmptyState('لا توجد استشارات معلقة', Icons.pending_actions);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingConsultations.length,
      itemBuilder: (context, index) {
        final consultation = _pendingConsultations[index];
        return _buildPendingConsultationCard(consultation);
      },
    );
  }

  Widget _buildActiveConsultations() {
    if (_activeConsultations.isEmpty) {
      return _buildEmptyState('لا توجد استشارات نشطة', Icons.medical_services);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activeConsultations.length,
      itemBuilder: (context, index) {
        final consultation = _activeConsultations[index];
        return _buildActiveConsultationCard(consultation);
      },
    );
  }

  Widget _buildCompletedConsultations() {
    if (_completedConsultations.isEmpty) {
      return _buildEmptyState('لا توجد استشارات مكتملة', Icons.check_circle);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _completedConsultations.length,
      itemBuilder: (context, index) {
        final consultation = _completedConsultations[index];
        return _buildCompletedConsultationCard(consultation);
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.titleLarge.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingConsultationCard(Map<String, dynamic> consultation) {
    Color priorityColor = _getPriorityColor(consultation['priority']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: 2,
        ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation['patientName'],
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'العمر: ${consultation['patientAge']} سنة',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
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
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: priorityColor),
                  ),
                  child: Text(
                    consultation['priority'],
                    style: AppTheme.bodySmall.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.doctorColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultation['subject'],
                    style: AppTheme.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.doctorColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    consultation['description'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(consultation['date']),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptConsultation(consultation),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('قبول'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewConsultationDetails(consultation),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('عرض'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.doctorColor,
                      side: BorderSide(color: AppTheme.doctorColor),
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
    );
  }

  Widget _buildActiveConsultationCard(Map<String, dynamic> consultation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.doctorColor.withValues(alpha: 0.3),
          width: 2,
        ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation['patientName'],
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'العمر: ${consultation['patientAge']} سنة',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
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
                    color: AppTheme.doctorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.doctorColor),
                  ),
                  child: Text(
                    consultation['status'],
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.doctorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.doctorColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultation['subject'],
                    style: AppTheme.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.doctorColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    consultation['description'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.update, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'آخر تحديث: ${_formatDateTime(consultation['lastUpdate'])}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _continueConsultation(consultation),
                    icon: const Icon(Icons.chat, size: 18),
                    label: const Text('متابعة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.doctorColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _completeConsultation(consultation),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('إنهاء'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.successColor,
                      side: BorderSide(color: AppTheme.successColor),
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
    );
  }

  Widget _buildCompletedConsultationCard(Map<String, dynamic> consultation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
          width: 2,
        ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation['patientName'],
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'العمر: ${consultation['patientAge']} سنة',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
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
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.successColor),
                  ),
                  child: Text(
                    'مكتملة',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultation['subject'],
                    style: AppTheme.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'التشخيص: ${consultation['diagnosis']}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (consultation['treatment'] != 'لا يوجد علاج مطلوب') ...[
                    const SizedBox(height: 4),
                    Text(
                      'العلاج: ${consultation['treatment']}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppTheme.successColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'اكتملت في: ${_formatDateTime(consultation['completedDate'])}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _viewConsultationDetails(consultation),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('عرض التفاصيل'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.successColor,
                  side: BorderSide(color: AppTheme.successColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Action methods
  void _acceptConsultation(Map<String, dynamic> consultation) {
    setState(() {
      _pendingConsultations.remove(consultation);
      consultation['status'] = 'قيد المتابعة';
      consultation['lastUpdate'] = DateTime.now();
      _activeConsultations.add(consultation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم قبول استشارة ${consultation['patientName']}'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _continueConsultation(Map<String, dynamic> consultation) {
    // Navigate to chat screen with patient
    Navigator.pushNamed(
      context,
      '/doctor/chat',
      arguments: {
        'patientId': consultation['id'],
        'patientName': consultation['patientName'],
      },
    );
  }

  void _completeConsultation(Map<String, dynamic> consultation) {
    showDialog(
      context: context,
      builder: (context) {
        final diagnosisController = TextEditingController();
        final treatmentController = TextEditingController();

        return AlertDialog(
          title: const Text('إنهاء الاستشارة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: diagnosisController,
                  decoration: const InputDecoration(
                    labelText: 'التشخيص',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: treatmentController,
                  decoration: const InputDecoration(
                    labelText: 'العلاج المقترح',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                if (diagnosisController.text.isNotEmpty) {
                  setState(() {
                    _activeConsultations.remove(consultation);
                    consultation['diagnosis'] = diagnosisController.text;
                    consultation['treatment'] =
                        treatmentController.text.isNotEmpty
                        ? treatmentController.text
                        : 'لا يوجد علاج مطلوب';
                    consultation['completedDate'] = DateTime.now();
                    _completedConsultations.add(consultation);
                  });
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إنهاء استشارة ${consultation['patientName']}',
                      ),
                      backgroundColor: AppTheme.successColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: const Text('إنهاء'),
            ),
          ],
        );
      },
    );
  }

  void _viewConsultationDetails(Map<String, dynamic> consultation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تفاصيل استشارة ${consultation['patientName']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('اسم المريض', consultation['patientName']),
                _buildDetailRow('العمر', '${consultation['patientAge']} سنة'),
                _buildDetailRow('الموضوع', consultation['subject']),
                _buildDetailRow('الوصف', consultation['description']),
                if (consultation['symptoms'] != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'الأعراض:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...consultation['symptoms'].map<Widget>(
                    (symptom) => Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text('• $symptom'),
                    ),
                  ),
                ],
                if (consultation['medicalHistory'] != null) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'التاريخ المرضي:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...consultation['medicalHistory'].map<Widget>(
                    (history) => Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text('• $history'),
                    ),
                  ),
                ],
                if (consultation['diagnosis'] != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow('التشخيص', consultation['diagnosis']),
                ],
                if (consultation['treatment'] != null) ...[
                  _buildDetailRow('العلاج', consultation['treatment']),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
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
}
