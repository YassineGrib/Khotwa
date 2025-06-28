import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/performance_utils.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _chatRooms = [];
  Map<String, dynamic>? _selectedChatRoom;
  List<Map<String, dynamic>> _messages = [];

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
    _loadChatRooms();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadChatRooms() {
    // Sample data - will be replaced with actual API calls
    _chatRooms = [
      {
        'id': '1',
        'patientName': 'أحمد محمد',
        'patientAge': 35,
        'lastMessage': 'شكراً دكتور على المتابعة',
        'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 15)),
        'unreadCount': 2,
        'isOnline': true,
        'consultationSubject': 'ألم في الصدر',
      },
      {
        'id': '2',
        'patientName': 'فاطمة علي',
        'patientAge': 28,
        'lastMessage': 'متى يمكنني تناول الدواء؟',
        'lastMessageTime': DateTime.now().subtract(const Duration(hours: 2)),
        'unreadCount': 0,
        'isOnline': false,
        'consultationSubject': 'صداع مستمر',
      },
      {
        'id': '3',
        'patientName': 'محمد سالم',
        'patientAge': 42,
        'lastMessage': 'تحسنت حالتي كثيراً',
        'lastMessageTime': DateTime.now().subtract(const Duration(hours: 5)),
        'unreadCount': 1,
        'isOnline': true,
        'consultationSubject': 'متابعة علاج السكري',
      },
    ];
  }

  void _loadMessages(String chatRoomId) {
    // Sample messages - will be replaced with actual API calls
    _messages = [
      {
        'id': '1',
        'senderId': chatRoomId,
        'senderName': _selectedChatRoom!['patientName'],
        'message': 'السلام عليكم دكتور',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'isFromDoctor': false,
        'messageType': 'text',
      },
      {
        'id': '2',
        'senderId': 'doctor',
        'senderName': 'د. أحمد محمد',
        'message': 'وعليكم السلام، كيف حالك اليوم؟',
        'timestamp': DateTime.now().subtract(
          const Duration(hours: 2, minutes: 55),
        ),
        'isFromDoctor': true,
        'messageType': 'text',
      },
      {
        'id': '3',
        'senderId': chatRoomId,
        'senderName': _selectedChatRoom!['patientName'],
        'message': 'أشعر بتحسن ولكن لا زال هناك بعض الألم',
        'timestamp': DateTime.now().subtract(
          const Duration(hours: 2, minutes: 50),
        ),
        'isFromDoctor': false,
        'messageType': 'text',
      },
      {
        'id': '4',
        'senderId': 'doctor',
        'senderName': 'د. أحمد محمد',
        'message': 'هذا طبيعي، استمر على العلاج كما وصفته لك',
        'timestamp': DateTime.now().subtract(
          const Duration(hours: 2, minutes: 45),
        ),
        'isFromDoctor': true,
        'messageType': 'text',
      },
      {
        'id': '5',
        'senderId': chatRoomId,
        'senderName': _selectedChatRoom!['patientName'],
        'message': 'شكراً دكتور على المتابعة',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'isFromDoctor': false,
        'messageType': 'text',
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
          title: _selectedChatRoom == null
              ? const Text('المحادثات')
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppTheme.doctorColor.withValues(
                        alpha: 0.1,
                      ),
                      child: Icon(Icons.person, color: AppTheme.doctorColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedChatRoom!['patientName'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            _selectedChatRoom!['isOnline']
                                ? 'متصل الآن'
                                : 'غير متصل',
                            style: TextStyle(
                              fontSize: 12,
                              color: _selectedChatRoom!['isOnline']
                                  ? AppTheme.successColor
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          backgroundColor: AppTheme.doctorColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          actions: _selectedChatRoom != null
              ? [
                  IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: _makeVoiceCall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: _makeVideoCall,
                  ),
                  PopupMenuButton<String>(
                    onSelected: _handleMenuAction,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view_profile',
                        child: Text('عرض الملف الشخصي'),
                      ),
                      const PopupMenuItem(
                        value: 'consultation_history',
                        child: Text('تاريخ الاستشارات'),
                      ),
                      const PopupMenuItem(
                        value: 'block_patient',
                        child: Text('حظر المريض'),
                      ),
                    ],
                  ),
                ]
              : null,
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _selectedChatRoom == null
                ? _buildChatRoomsList()
                : _buildChatInterface(),
          ),
        ),
      ),
    );
  }

  Widget _buildChatRoomsList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'البحث في المحادثات...',
              prefixIcon: Icon(Icons.search, color: AppTheme.doctorColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: PerformanceUtils.buildOptimizedListView(
            itemCount: _chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = _chatRooms[index];
              return _buildChatRoomItem(chatRoom);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatRoomItem(Map<String, dynamic> chatRoom) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.doctorColor.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: AppTheme.doctorColor, size: 30),
            ),
            if (chatRoom['isOnline'])
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                chatRoom['patientName'],
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              _formatTime(chatRoom['lastMessageTime']),
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatRoom['consultationSubject'],
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.doctorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    chatRoom['lastMessage'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (chatRoom['unreadCount'] > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.doctorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${chatRoom['unreadCount']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => _selectChatRoom(chatRoom),
      ),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isFromDoctor = message['isFromDoctor'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isFromDoctor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isFromDoctor) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.doctorColor.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: AppTheme.doctorColor, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromDoctor
                    ? AppTheme.doctorColor
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isFromDoctor
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isFromDoctor
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['message'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: isFromDoctor ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMessageTime(message['timestamp']),
                    style: AppTheme.bodySmall.copyWith(
                      color: isFromDoctor
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromDoctor) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.doctorColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.medical_services,
                color: AppTheme.doctorColor,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: AppTheme.doctorColor),
            onPressed: _attachFile,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.doctorColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  String _formatMessageTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Action methods
  void _selectChatRoom(Map<String, dynamic> chatRoom) {
    setState(() {
      _selectedChatRoom = chatRoom;
      // Mark messages as read
      chatRoom['unreadCount'] = 0;
    });
    _loadMessages(chatRoom['id']);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'senderId': 'doctor',
      'senderName': 'د. أحمد محمد',
      'message': _messageController.text.trim(),
      'timestamp': DateTime.now(),
      'isFromDoctor': true,
      'messageType': 'text',
    };

    setState(() {
      _messages.add(newMessage);
      // Update last message in chat room
      _selectedChatRoom!['lastMessage'] = _messageController.text.trim();
      _selectedChatRoom!['lastMessageTime'] = DateTime.now();
    });

    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _attachFile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إرفاق ملف',
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    Icons.photo,
                    'صورة',
                    () => _attachImage(),
                  ),
                  _buildAttachmentOption(
                    Icons.description,
                    'مستند',
                    () => _attachDocument(),
                  ),
                  _buildAttachmentOption(
                    Icons.mic,
                    'تسجيل صوتي',
                    () => _recordAudio(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.doctorColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.doctorColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  void _makeVoiceCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'بدء مكالمة صوتية مع ${_selectedChatRoom!['patientName']}',
        ),
        backgroundColor: AppTheme.doctorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _makeVideoCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'بدء مكالمة فيديو مع ${_selectedChatRoom!['patientName']}',
        ),
        backgroundColor: AppTheme.doctorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'view_profile':
        Navigator.pushNamed(
          context,
          '/patient/profile',
          arguments: {'patientId': _selectedChatRoom!['id']},
        );
        break;
      case 'consultation_history':
        Navigator.pushNamed(
          context,
          '/doctor/consultations',
          arguments: {'patientId': _selectedChatRoom!['id']},
        );
        break;
      case 'block_patient':
        _showBlockPatientDialog();
        break;
    }
  }

  void _showBlockPatientDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حظر المريض'),
          content: Text(
            'هل أنت متأكد من حظر ${_selectedChatRoom!['patientName']}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedChatRoom = null;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم حظر ${_selectedChatRoom!['patientName']}',
                    ),
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
              child: const Text('حظر'),
            ),
          ],
        );
      },
    );
  }

  void _attachImage() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة ميزة إرفاق الصور قريباً')),
    );
  }

  void _attachDocument() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة ميزة إرفاق المستندات قريباً')),
    );
  }

  void _recordAudio() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة ميزة التسجيل الصوتي قريباً')),
    );
  }
}
