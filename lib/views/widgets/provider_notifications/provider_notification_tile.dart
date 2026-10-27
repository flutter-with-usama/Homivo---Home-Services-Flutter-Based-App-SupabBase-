import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/notification_model.dart';

/// Single provider notification row.
/// Deep-purple accent for unread state.
/// Swipe left to dismiss.
class ProviderNotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const ProviderNotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFEF4444),
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : AppTheme.deepPurple.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? const Color(0xFFF0F0F0)
                  : AppTheme.deepPurple.withValues(alpha: 0.20),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon badge ─────────────────────────────────────────────
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: notification.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.color,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              // ── Content ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + unread dot
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: const Color(0xFF1A1A2E),
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 3),
                            decoration: const BoxDecoration(
                              color: AppTheme.deepPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Body
                    Text(
                      notification.body,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textGrey,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Time
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: notification.isRead
                            ? AppTheme.textGrey
                            : AppTheme.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
