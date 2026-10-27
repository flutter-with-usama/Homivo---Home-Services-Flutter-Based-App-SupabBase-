import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/provider_profile_model.dart';
import '../../viewmodels/chat_viewmodel.dart';
import '../widgets/chat/chat_app_bar.dart';
import '../widgets/chat/chat_bubble.dart';
import '../widgets/chat/chat_input_bar.dart';

/// Full chat screen — works from both the provider detail flow
/// (via [ChatScreen.fromProvider]) and the messages list
/// (via [ChatScreen.fromConversation]).
class ChatScreen extends StatefulWidget {
  final String name;
  final String initials;
  final Color avatarColor;
  final bool isOnline;
  final Color serviceColor;
  final String? conversationId;
  final String? providerId;

  // ── Named constructor from ProviderProfileModel ────────────────────────────
  ChatScreen.fromProvider({
    super.key,
    required ProviderProfileModel provider,
    required this.serviceColor,
  }) : name = provider.name,
       initials = provider.initials,
       avatarColor = provider.avatarColor,
       isOnline = false,
       conversationId = null,
       providerId = provider.id;

  // ── Named constructor from ConversationModel ───────────────────────────────
  ChatScreen.fromConversation({
    super.key,
    required ConversationModel conversation,
  }) : name = conversation.name,
       initials = conversation.initials,
       avatarColor = conversation.avatarColor,
       isOnline = conversation.isOnline,
       serviceColor = AppTheme.primary,
       conversationId = conversation.id,
       providerId = null;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _vm;
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _vm = ChatViewModel(
      initialConversationId: widget.conversationId,
      providerId: widget.providerId,
    );
    _vm.addListener(_onNewMessage);
  }

  @override
  void dispose() {
    _vm.removeListener(_onNewMessage);
    _vm.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onNewMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),

      // ── 1. App bar ─────────────────────────────────────────────────────
      appBar: ChatAppBar(
        name: widget.name,
        initials: widget.initials,
        avatarColor: widget.avatarColor,
        isOnline: widget.isOnline,
      ),

      // ── 2. Input bar ───────────────────────────────────────────────────
      bottomNavigationBar: ChatInputBar(onSend: _vm.sendMessage),

      // ── 3. Message list ────────────────────────────────────────────────
      body: AnimatedBuilder(
        animation: _vm,
        builder: (context, _) {
          final messages = _vm.messages;
          if (_vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_vm.errorMessage != null && messages.isEmpty) {
            return _ChatStateMessage(message: _vm.errorMessage!);
          }
          if (messages.isEmpty) {
            return const _ChatStateMessage(
              message: 'No messages yet.\nSend the first message.',
            );
          }
          return ListView.builder(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
            itemCount: messages.length,
            itemBuilder: (_, i) {
              final msg = messages[i];
              final showDate =
                  i == 0 ||
                  !_isSameDay(messages[i - 1].createdAt, msg.createdAt);
              return Column(
                children: [
                  if (showDate) _DateSeparator(date: _dateLabel(msg.createdAt)),
                  ChatBubble(message: msg),
                ],
              );
            },
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) return 'Today';

    final yesterday = now.subtract(const Duration(days: 1));
    if (_isSameDay(date, yesterday)) return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ChatStateMessage extends StatelessWidget {
  final String message;

  const _ChatStateMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.textGrey),
      ),
    );
  }
}

// ── Date separator ────────────────────────────────────────────────────────────
class _DateSeparator extends StatelessWidget {
  final String date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFFE8E8E8))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
              ),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: const Color(0xFFE8E8E8))),
        ],
      ),
    );
  }
}
