import 'package:flutter/material.dart';

/// Status of the last message in a conversation.
enum MessageStatus { read, pending, unread }

/// A single conversation thread shown in the messages list.
class ConversationModel {
  final String id;
  final String name;
  final String initials;
  final Color avatarColor;
  final String lastMessage;
  final String time; // e.g. "2m ago"
  final bool isOnline;
  final bool isNameBold; // active / unread conversation
  final MessageStatus status;
  final int unreadCount; // 0 = no badge

  const ConversationModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.isNameBold = false,
    this.status = MessageStatus.read,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromMap(
    Map<String, dynamic> map,
    String currentUserId,
  ) {
    final isClient = map['client_id'] == currentUserId;
    final name =
        (isClient ? map['provider_name'] : map['client_name']) as String? ?? '';
    final updatedAt =
        DateTime.tryParse(map['updated_at'] as String? ?? '')?.toLocal() ??
        DateTime.now();

    return ConversationModel(
      id: map['id'] as String? ?? '',
      name: name,
      initials: _initials(name),
      avatarColor: _avatarColor(map['id'] as String? ?? ''),
      lastMessage: map['last_message'] as String? ?? '',
      time: _relativeTime(updatedAt),
      isOnline: false,
      status: MessageStatus.read,
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  static Color _avatarColor(String id) {
    const colors = [
      Color(0xFF00C566),
      Color(0xFF0EA5E9),
      Color(0xFF8B5CF6),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  static String _relativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
