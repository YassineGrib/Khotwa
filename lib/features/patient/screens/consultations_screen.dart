import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/performance_utils.dart';
import '../../../core/services/auth_validation.dart';
import 'package:file_picker/file_picker.dart';

class ConsultationsScreen extends StatefulWidget {
  const ConsultationsScreen({super.key});

  @override
  State<ConsultationsScreen> createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('الاستشارات الطبية'),
        backgroundColor: AppTheme.patientColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.add_circle_outline), text: 'استشارة جديدة'),
            Tab(icon: Icon(Icons.history), text: 'استشاراتي'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: TabBarView(
            controller: _tabController,
            children: [_buildNewConsultationTab(), _buildMyConsultationsTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildNewConsultationTab() {
    return const NewConsultationForm();
  }

  Widget _buildMyConsultationsTab() {
    return const MyConsultationsList();
  }
}

class NewConsultationForm extends StatefulWidget {
  const NewConsultationForm({super.key});

  @override
  State<NewConsultationForm> createState() => _NewConsultationFormState();
}

class _NewConsultationFormState extends State<NewConsultationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _symptomsController = TextEditingController();

  String _selectedSpecialty = 'طبيب عظام';
  String _selectedUrgency = 'عادي';
  bool _isLoading = false;
  bool _isPaymentDone = false;

  final List<String> _specialties = [
    'طبيب عظام',
    'فني تصنيع الأطراف الاصطناعية',
    'أخصائي التأهيل الحركي',
    'مرشد اجتماعي',
    'نفساني',
  ];

  final List<String> _urgencyLevels = ['عادي', 'مهم', 'عاجل', 'طارئ'];

  final List<Map<String, dynamic>> _attachedFiles = [];
  final List<String> _docTypes = [
    'وصفة طبية',
    'وثيقة طبية',
    'وثيقة إدارية',
    'أخرى',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('تفاصيل الاستشارة'),
            _buildConsultationDetailsSection(),
            const SizedBox(height: 30),
            _buildSectionHeader('التخصص والأولوية'),
            _buildSpecialtySection(),
            const SizedBox(height: 30),
            _buildSectionHeader('الأعراض والتفاصيل'),
            _buildSymptomsSection(),
            const SizedBox(height: 40),
            _buildAttachmentsSection(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: AppTheme.headlineSmall.copyWith(
          color: AppTheme.patientColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConsultationDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: AppTheme.getInputDecoration(
              labelText: 'عنوان الاستشارة',
              prefixIcon: Icons.title,
              hintText: 'مثال: ألم في الركبة بعد سقوط في سطيف',
            ),
            validator: (value) =>
                AuthValidation.validateRequired(value, 'عنوان الاستشارة'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: AppTheme.getInputDecoration(
              labelText: 'وصف المشكلة',
              prefixIcon: Icons.description,
              hintText: 'اشرح مشكلتك بالتفصيل، مثلاً: شعرت بألم حاد في الركبة بعد حادث في سطيف، مع صعوبة في الحركة...',
            ),
            validator: (value) =>
                AuthValidation.validateRequired(value, 'وصف المشكلة'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedSpecialty,
            decoration: AppTheme.getInputDecoration(
              labelText: 'التخصص المطلوب',
              prefixIcon: Icons.medical_services,
            ),
            items: _specialties.map((specialty) {
              return DropdownMenuItem(value: specialty, child: Text(specialty));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSpecialty = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedUrgency,
            decoration: AppTheme.getInputDecoration(
              labelText: 'مستوى الأولوية',
              prefixIcon: Icons.priority_high,
            ),
            items: _urgencyLevels.map((urgency) {
              return DropdownMenuItem(
                value: urgency,
                child: Row(
                  children: [
                    Icon(
                      _getUrgencyIcon(urgency),
                      color: _getUrgencyColor(urgency),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(urgency),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedUrgency = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
          if (!_isPaymentDone) {
            final paid = await showDialog<bool>(
              context: context,
              builder: (context) => PaymentDialog(),
            );
            if (paid == true) {
              setState(() {
                _isPaymentDone = true;
              });
            } else {
              return;
            }
          }
          _submitConsultation();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.patientColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'إرسال الاستشارة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  IconData _getUrgencyIcon(String urgency) {
    switch (urgency) {
      case 'عادي':
        return Icons.info_outline;
      case 'مهم':
        return Icons.warning_amber_outlined;
      case 'عاجل':
        return Icons.priority_high;
      case 'طارئ':
        return Icons.emergency;
      default:
        return Icons.info_outline;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'عادي':
        return Colors.blue;
      case 'مهم':
        return Colors.orange;
      case 'عاجل':
        return Colors.red;
      case 'طارئ':
        return Colors.red[800]!;
      default:
        return Colors.blue;
    }
  }

  Future<void> _submitConsultation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Submit consultation to backend

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إرسال الاستشارة بنجاح'),
            backgroundColor: AppTheme.patientColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _symptomsController.clear();
        setState(() {
          _selectedSpecialty = 'طبيب عظام';
          _selectedUrgency = 'عادي';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSymptomsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _symptomsController,
        maxLines: 5,
        decoration: AppTheme.getInputDecoration(
          labelText: 'الأعراض التفصيلية',
          prefixIcon: Icons.sick,
          hintText: 'اذكر جميع الأعراض التي تشعر بها، متى بدأت، شدتها، مثلاً: ألم مستمر في الركبة، تورم، صعوبة في المشي...',
        ),
        validator: (value) =>
            AuthValidation.validateRequired(value, 'الأعراض التفصيلية'),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _attachedFiles.add({
          'file': result.files.first,
          'type': _docTypes.first,
        });
      });
    }
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إرفاق ملفات (اختياري)',
          style: AppTheme.titleSmall.copyWith(
            color: AppTheme.patientColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.attach_file),
          label: const Text('إرفاق ملف'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.patientColor,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        ..._attachedFiles.asMap().entries.map((entry) {
          int idx = entry.key;
          var file = entry.value['file'];
          return Row(
            children: [
              Expanded(child: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: entry.value['type'],
                items: _docTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (val) {
                  setState(() {
                    _attachedFiles[idx]['type'] = val!;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _attachedFiles.removeAt(idx);
                  });
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}

class MyConsultationsList extends StatefulWidget {
  const MyConsultationsList({super.key});

  @override
  State<MyConsultationsList> createState() => _MyConsultationsListState();
}

class _MyConsultationsListState extends State<MyConsultationsList> {
  final List<Map<String, dynamic>> _consultations = [
    {
      'id': '1',
      'title': 'ألم في الصدر',
      'specialty': 'طب العظام',
      'urgency': 'عاجل',
      'status': 'قيد المراجعة',
      'date': '2024-01-15',
      'doctor': null,
    },
    {
      'id': '2',
      'title': 'صداع مستمر',
      'specialty': 'أخصائي التأهيل الحركي',
      'urgency': 'مهم',
      'status': 'تم الرد',
      'date': '2024-01-10',
      'doctor': 'د. أحمد محمد',
      'response':
          'يُنصح بإجراء فحص شامل للرأس والعينين. تجنب التوتر والحصول على قسط كافٍ من النوم.',
    },
    {
      'id': '3',
      'title': 'آلام في المعدة',
      'specialty': 'فني تصنيع الأطراف الاصطناعية',
      'urgency': 'عادي',
      'status': 'مكتملة',
      'date': '2024-01-05',
      'doctor': 'د. فاطمة علي',
      'response':
          'تم تشخيص الحالة كعسر هضم بسيط. يُنصح بتناول وجبات صغيرة ومتكررة وتجنب الأطعمة الحارة.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _consultations.isEmpty
        ? _buildEmptyState()
        : PerformanceUtils.buildOptimizedListView(
            itemCount: _consultations.length,
            itemBuilder: (context, index) {
              final consultation = _consultations[index];
              return _buildConsultationCard(consultation);
            },
            padding: const EdgeInsets.all(20.0),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_information_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد استشارات',
            style: AppTheme.headlineSmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإرسال استشارة جديدة',
            style: AppTheme.bodyMedium.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(Map<String, dynamic> consultation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  consultation['title'],
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(consultation['status']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.medical_services, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                consultation['specialty'],
                style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                consultation['date'],
                style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          if (consultation['doctor'] != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppTheme.patientColor),
                const SizedBox(width: 8),
                Text(
                  consultation['doctor'],
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.patientColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (consultation['response'] != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.patientColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رد الطبيب:',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.patientColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(consultation['response'], style: AppTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'قيد المراجعة':
        backgroundColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange[800]!;
        icon = Icons.hourglass_empty;
        break;
      case 'تم الرد':
        backgroundColor = Colors.blue.withValues(alpha: 0.2);
        textColor = Colors.blue[800]!;
        icon = Icons.reply;
        break;
      case 'مكتملة':
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green[800]!;
        icon = Icons.check_circle;
        break;
      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.2);
        textColor = Colors.grey[800]!;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentDialog extends StatefulWidget {
  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String _selectedMethod = 'البطاقة الذهبية';
  bool _isPaid = false;
  bool _isPending = false;
  String? _receiptPath;
  final _operationNumberController = TextEditingController();

  @override
  void dispose() {
    _operationNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('دفع الاستشارة'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text('سعر الاستشارة', style: AppTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('1500 دج', style: AppTheme.headlineMedium.copyWith(color: AppTheme.successColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            Text('اختر طريقة الدفع:', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedMethod,
              items: const [
                DropdownMenuItem(value: 'البطاقة الذهبية', child: Text('الدفع الإلكتروني (البطاقة الذهبية)')),
                DropdownMenuItem(value: 'تحويل بنكي', child: Text('تحويل بنكي')),
                DropdownMenuItem(value: 'تحويل بريدي', child: Text('تحويل بريدي')),
              ],
              onChanged: (val) {
                setState(() {
                  _selectedMethod = val!;
                  _isPaid = false;
                  _isPending = false;
                  _receiptPath = null;
                  _operationNumberController.clear();
                });
              },
            ),
            const SizedBox(height: 24),
            if (_selectedMethod == 'البطاقة الذهبية') ...[
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isPaid
                      ? null
                      : () {
                          setState(() {
                            _isPaid = true;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('تم الدفع بنجاح!'),
                              content: const Text('تمت محاكاة عملية الدفع بنجاح. يمكنك الآن إرسال الاستشارة.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('حسناً'),
                                ),
                              ],
                            ),
                          );
                        },
                  icon: const Icon(Icons.credit_card),
                  label: const Text('دفع إلكتروني'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            if (_selectedMethod == 'تحويل بنكي' || _selectedMethod == 'تحويل بريدي') ...[
              Text('ارفع صورة/وصل التحويل:', style: AppTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                      if (result != null && result.files.isNotEmpty) {
                        setState(() {
                          _receiptPath = result.files.first.path;
                        });
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('رفع الوصل'),
                  ),
                  const SizedBox(width: 12),
                  if (_receiptPath != null)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _operationNumberController,
                decoration: const InputDecoration(
                  labelText: 'رقم العملية',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isPending
                      ? null
                      : () {
                          setState(() {
                            _isPending = true;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('تم إرسال الطلب!'),
                              content: const Text('تم إرسال بيانات التحويل بنجاح. يمكنك الآن إرسال الاستشارة بعد التحقق.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('حسناً'),
                                ),
                              ],
                            ),
                          );
                        },
                  icon: const Icon(Icons.send),
                  label: const Text('إرسال الطلب'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.patientColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            Divider(),
            const SizedBox(height: 16),
            Text('حالة الدفع:', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: _isPaid
                  ? _buildStatusChip('مدفوع')
                  : _isPending
                      ? _buildStatusChip('بانتظار التحقق')
                      : _buildStatusChip('غير مدفوع'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: (_isPaid || _isPending)
              ? () => Navigator.pop(context, true)
              : null,
          child: const Text('متابعة'),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'مدفوع':
        color = Colors.green;
        break;
      case 'بانتظار التحقق':
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
