import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/performance_utils.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('المحادثات'),
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
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildChatsList(),
        ),
      ),
    );
  }

  Widget _buildChatsList() {
    final chats = _getSampleChats();

    if (chats.isEmpty) {
      return _buildEmptyState();
    }

    return PerformanceUtils.buildOptimizedListView(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatCard(chat);
      },
      padding: const EdgeInsets.all(16.0),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.patientColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: AppTheme.patientColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد محادثات بعد',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ابدأ محادثة مع طبيب من خلال الاستشارات',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/consultations'),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('إرسال استشارة جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.patientColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    final bool hasUnread = chat['unreadCount'] > 0;
    final bool isOnline = chat['isOnline'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.patientColor.withValues(alpha: 0.1),
              child: Text(
                chat['doctorName'].toString().substring(0, 1),
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.patientColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat['doctorName'],
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            Text(
              chat['time'],
              style: AppTheme.bodySmall.copyWith(
                color: hasUnread
                    ? AppTheme.patientColor
                    : AppTheme.textSecondary,
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat['specialty'],
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.patientColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    chat['lastMessage'],
                    style: AppTheme.bodyMedium.copyWith(
                      color: hasUnread
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                      fontWeight: hasUnread
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasUnread)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.patientColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chat['unreadCount'].toString(),
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => _openChatConversation(context, chat),
      ),
    );
  }

  void _openChatConversation(BuildContext context, Map<String, dynamic> chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationScreen(
          doctorName: chat['doctorName'],
          doctorSpecialty: chat['specialty'],
          doctorId: chat['doctorId'],
          isOnline: chat['isOnline'] ?? false,
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في المحادثات'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'ابحث عن طبيب أو رسالة...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  List<Map<String, dynamic>> _getSampleChats() {
    return [
      {
        'doctorId': '1',
        'doctorName': 'د. أحمد محمد',
        'specialty': 'طب العظام',
        'lastMessage': 'يمكنك البدء بالتمارين التي أرسلتها لك',
        'time': '10:30 ص',
        'unreadCount': 2,
        'isOnline': true,
      },
      {
        'doctorId': '2',
        'doctorName': 'د. فاطمة علي',
        'specialty': 'طب عام',
        'lastMessage': 'شكراً لك، أتمنى لك الشفاء العاجل',
        'time': 'أمس',
        'unreadCount': 0,
        'isOnline': false,
      },
      {
        'doctorId': '3',
        'doctorName': 'د. محمد السعيد',
        'specialty': 'طب القلب',
        'lastMessage': 'تحتاج لإجراء فحص دوري كل 3 أشهر',
        'time': '3 أيام',
        'unreadCount': 1,
        'isOnline': true,
      },
    ];
  }
}

// Chat Conversation Screen will be implemented in the next part
class ChatConversationScreen extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorId;
  final bool isOnline;

  const ChatConversationScreen({
    super.key,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorId,
    required this.isOnline,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Auto scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            _buildTypingIndicator(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.patientColor,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  widget.doctorName.substring(0, 1),
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctorName,
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.isOnline ? 'متصل الآن' : 'غير متصل',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () => _showFeatureComingSoon('مكالمة فيديو'),
        ),
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () => _showFeatureComingSoon('مكالمة صوتية'),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'rate',
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('تقييم الطبيب'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.report, color: Colors.red),
                  SizedBox(width: 8),
                  Text('إبلاغ'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    final messages = _getSampleMessages();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['isMe'] as bool;
        final isConsecutive = index > 0 && messages[index - 1]['isMe'] == isMe;

        return _buildMessageBubble(message, isConsecutive);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isConsecutive) {
    final bool isMe = message['isMe'];
    final String text = message['text'];
    final String time = message['time'];
    final String? type = message['type'];

    return Container(
      margin: EdgeInsets.only(
        bottom: isConsecutive ? 4 : 16,
        left: isMe ? 50 : 0,
        right: isMe ? 0 : 50,
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.patientColor : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
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
                if (type == 'exercise')
                  _buildExerciseMessage(message)
                else if (type == 'image')
                  _buildImageMessage(message)
                else
                  _buildTextMessage(text, isMe),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTheme.bodySmall.copyWith(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessage(String text, bool isMe) {
    return Text(
      text,
      style: AppTheme.bodyMedium.copyWith(
        color: isMe ? Colors.white : AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildExerciseMessage(Map<String, dynamic> message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'تمرين علاجي',
                style: AppTheme.titleSmall.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message['text'],
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _showFeatureComingSoon('مشاهدة الفيديو'),
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text('مشاهدة الفيديو'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(Map<String, dynamic> message) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          if (message['text'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message['text'],
                style: AppTheme.bodySmall.copyWith(color: AppTheme.textPrimary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    if (!_isTyping) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.patientColor.withValues(alpha: 0.1),
            child: Text(
              widget.doctorName.substring(0, 1),
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.patientColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double animationValue =
            (_animationController.value + index * 0.2) % 1.0;
        return Transform.translate(
          offset: Offset(
            0,
            -4 *
                (animationValue < 0.5
                    ? animationValue * 2
                    : (1 - animationValue) * 2),
          ),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => _showAttachmentOptions(),
              icon: Icon(Icons.attach_file, color: AppTheme.patientColor),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالتك...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.patientColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // TODO: Send message to backend
    _messageController.clear();

    // Simulate typing response
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    });

    _scrollToBottom();
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'إرفاق ملف',
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    Icons.camera_alt,
                    'كاميرا',
                    Colors.blue,
                    () => _showFeatureComingSoon('الكاميرا'),
                  ),
                  _buildAttachmentOption(
                    Icons.photo_library,
                    'الصور',
                    Colors.green,
                    () => _showFeatureComingSoon('معرض الصور'),
                  ),
                  _buildAttachmentOption(
                    Icons.insert_drive_file,
                    'ملف',
                    Colors.orange,
                    () => _showFeatureComingSoon('إرفاق ملف'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showFeatureComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - قريباً'),
        backgroundColor: AppTheme.patientColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'rate':
        _showRatingDialog();
        break;
      case 'report':
        _showReportDialog();
        break;
    }
  }

  void _showRatingDialog() {
    int rating = 0;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'تقييم ${widget.doctorName}',
            style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'كيف كانت تجربتك مع الطبيب؟',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Icon(
                      Icons.star,
                      size: 40,
                      color: index < rating ? Colors.orange : Colors.grey[300],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'اكتب تعليقك (اختياري)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: rating > 0
                  ? () {
                      Navigator.pop(context);
                      _submitRating(rating, commentController.text);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.patientColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('إرسال التقييم'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    final TextEditingController reasonController = TextEditingController();
    String selectedReason = 'سلوك غير مهني';

    final List<String> reportReasons = [
      'سلوك غير مهني',
      'معلومات طبية خاطئة',
      'عدم الرد في الوقت المناسب',
      'طلب معلومات شخصية',
      'أخرى',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'إبلاغ عن ${widget.doctorName}',
            style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ما سبب الإبلاغ؟',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedReason,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: reportReasons.map((reason) {
                  return DropdownMenuItem(value: reason, child: Text(reason));
                }).toList(),
                onChanged: (value) => setState(() => selectedReason = value!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: 'تفاصيل إضافية (اختياري)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitReport(selectedReason, reasonController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('إرسال الإبلاغ'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating(int rating, String comment) {
    // TODO: Submit rating to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إرسال التقييم بنجاح ($rating نجوم)'),
        backgroundColor: AppTheme.patientColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _submitReport(String reason, String details) {
    // TODO: Submit report to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال الإبلاغ بنجاح. سيتم مراجعته من قبل الإدارة.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleMessages() {
    return [
      {
        'text': 'مرحباً دكتور، أشعر بألم في الركبة منذ أسبوع',
        'time': '9:30 ص',
        'isMe': true,
      },
      {
        'text': 'مرحباً بك، أفهم شعورك. هل يمكنك وصف الألم بتفصيل أكثر؟',
        'time': '9:32 ص',
        'isMe': false,
      },
      {
        'text': 'الألم يزداد عند المشي وخاصة عند صعود الدرج',
        'time': '9:35 ص',
        'isMe': true,
      },
      {
        'text': 'هذا يبدو كالتهاب في المفصل. سأرسل لك بعض التمارين المفيدة',
        'time': '9:37 ص',
        'isMe': false,
      },
      {
        'text':
            'تمارين تقوية عضلات الفخذ الأمامية - مارس هذه التمارين 3 مرات يومياً لمدة أسبوعين',
        'time': '9:38 ص',
        'isMe': false,
        'type': 'exercise',
      },
      {
        'text': 'شكراً دكتور، سأبدأ بالتمارين اليوم',
        'time': '9:40 ص',
        'isMe': true,
      },
      {
        'text': 'ممتاز، وإذا لم تتحسن الحالة خلال أسبوع تواصل معي مرة أخرى',
        'time': '9:42 ص',
        'isMe': false,
      },
    ];
  }
}
