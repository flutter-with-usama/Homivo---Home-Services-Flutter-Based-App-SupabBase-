import 'package:flutter/material.dart';

/// Category of a notification — drives icon and colour.
enum NotificationType {
  // ── Client types ───────────────────────────────────────────────────────────
  bookingAccepted,
  bookingRejected,
  bookingCompleted,
  bookingReminder,
  newMessage,
  paymentReceived,
  promoOffer,
  systemAlert,

  // ── Provider types ─────────────────────────────────────────────────────────
  newJobRequest, // a client sent a new job request
  jobAccepted, // provider accepted a job (confirmation)
  jobCompleted, // job marked as completed
  earningReceived, // payment credited to provider
}

/// A single notification item.
class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final String time; // display string e.g. "2 min ago"
  final DateTime dateTime; // for grouping
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.dateTime,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    final createdAt =
        DateTime.tryParse(map['created_at'] as String? ?? '')?.toLocal() ??
        DateTime.now();

    return NotificationModel(
      id: map['id'] as String? ?? '',
      type: _typeFromDatabase(map['type'] as String?),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      time: _relativeTime(createdAt),
      dateTime: createdAt,
      isRead: map['is_read'] as bool? ?? false,
    );
  }

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id,
    type: type,
    title: title,
    body: body,
    time: time,
    dateTime: dateTime,
    isRead: isRead ?? this.isRead,
  );

  static NotificationType _typeFromDatabase(String? value) => switch (value) {
    'booking_accepted' => NotificationType.bookingAccepted,
    'booking_rejected' => NotificationType.bookingRejected,
    'booking_completed' => NotificationType.bookingCompleted,
    'booking_reminder' => NotificationType.bookingReminder,
    'new_message' => NotificationType.newMessage,
    'payment_received' => NotificationType.paymentReceived,
    'promo_offer' => NotificationType.promoOffer,
    'new_job_request' => NotificationType.newJobRequest,
    'job_accepted' => NotificationType.jobAccepted,
    'job_completed' => NotificationType.jobCompleted,
    'earning_received' => NotificationType.earningReceived,
    _ => NotificationType.systemAlert,
  };

  static String _relativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    if (difference.inDays == 1) return 'Yesterday';
    return '${difference.inDays} days ago';
  }

  // ── Visual properties derived from type ───────────────────────────────────
  IconData get icon => switch (type) {
    NotificationType.bookingAccepted => Icons.check_circle_rounded,
    NotificationType.bookingRejected => Icons.cancel_rounded,
    NotificationType.bookingCompleted => Icons.task_alt_rounded,
    NotificationType.bookingReminder => Icons.access_time_rounded,
    NotificationType.newMessage => Icons.chat_bubble_rounded,
    NotificationType.paymentReceived => Icons.account_balance_wallet_rounded,
    NotificationType.promoOffer => Icons.local_offer_rounded,
    NotificationType.systemAlert => Icons.info_rounded,
    // Provider types
    NotificationType.newJobRequest => Icons.work_rounded,
    NotificationType.jobAccepted => Icons.handshake_rounded,
    NotificationType.jobCompleted => Icons.verified_rounded,
    NotificationType.earningReceived => Icons.payments_rounded,
  };

  Color get color => switch (type) {
    NotificationType.bookingAccepted => const Color(0xFF00C566),
    NotificationType.bookingRejected => const Color(0xFFEF4444),
    NotificationType.bookingCompleted => const Color(0xFF00B4D8),
    NotificationType.bookingReminder => const Color(0xFFF59E0B),
    NotificationType.newMessage => const Color(0xFF8B5CF6),
    NotificationType.paymentReceived => const Color(0xFF10B981),
    NotificationType.promoOffer => const Color(0xFFEC4899),
    NotificationType.systemAlert => const Color(0xFF6366F1),
    // Provider types
    NotificationType.newJobRequest => const Color(0xFF7E57C2),
    NotificationType.jobAccepted => const Color(0xFF00C566),
    NotificationType.jobCompleted => const Color(0xFF00B4D8),
    NotificationType.earningReceived => const Color(0xFF10B981),
  };

  Color get bgColor => switch (type) {
    NotificationType.bookingAccepted => const Color(0xFFD0F5E8),
    NotificationType.bookingRejected => const Color(0xFFFEE2E2),
    NotificationType.bookingCompleted => const Color(0xFFCFF4FC),
    NotificationType.bookingReminder => const Color(0xFFFEF3C7),
    NotificationType.newMessage => const Color(0xFFEDE9FE),
    NotificationType.paymentReceived => const Color(0xFFD1FAE5),
    NotificationType.promoOffer => const Color(0xFFFCE7F3),
    NotificationType.systemAlert => const Color(0xFFE0E7FF),
    // Provider types
    NotificationType.newJobRequest => const Color(0xFFEDE7F6),
    NotificationType.jobAccepted => const Color(0xFFD0F5E8),
    NotificationType.jobCompleted => const Color(0xFFCFF4FC),
    NotificationType.earningReceived => const Color(0xFFD1FAE5),
  };
}
