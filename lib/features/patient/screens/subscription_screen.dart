import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاشتراك الشهري'),
        backgroundColor: AppTheme.patientColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('سعر الاشتراك الشهري', style: AppTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('1000 دج / شهر', style: AppTheme.headlineMedium.copyWith(color: AppTheme.successColor, fontWeight: FontWeight.bold)),
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
                              content: const Text('تمت محاكاة عملية الدفع بنجاح. سيتم تفعيل اشتراكك قريباً.'),
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
                              content: const Text('تم إرسال بيانات التحويل بنجاح. سيتم مراجعة طلبك وتفعيل الاشتراك قريباً.'),
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
            Text('حالة الاشتراك:', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: _isPaid
                  ? _buildStatusChip('مشترك')
                  : _isPending
                      ? _buildStatusChip('بانتظار التحقق')
                      : _buildStatusChip('غير مشترك'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'مشترك':
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