import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/conversation_model.dart';

/// Single conversation row — avatar with online dot, name, last message,
/// time, status badge, and optional unread count badge.
class ConversationListTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback? onTap;

  const ConversationListTile({
    super.key,
    required this.conversation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar with online dot ─────────────────────────────────
            _Avatar(conversation: conversation),

            const SizedBox(width: 14),

            // ── Name + message + time + status ─────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Row(
                    children: [
                      // Online dot inline (for active conversations)
                      if (conversation.isNameBold) ...[
                        Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          conversation.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: conversation.isNameBold
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread count badge
                      if (conversation.unreadCount > 0)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${conversation.unreadCount}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // Last message
                  Text(
                    conversation.lastMessage,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Time + status row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      _StatusBadge(status: conversation.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar with online indicator ──────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final ConversationModel conversation;
  const _Avatar({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar circle
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: conversation.avatarColor.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              conversation.initials,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: conversation.avatarColor,
              ),
            ),
          ),
        ),
        // Online dot
        if (conversation.isOnline)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final MessageStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      MessageStatus.read    => ('Read', AppTheme.primary),
      MessageStatus.pending => ('Pending', AppTheme.textGrey),
      MessageStatus.unread  => ('Unread', AppTheme.textGrey),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(width: 3),
        Icon(Icons.check_rounded, size: 14, color: color),
      ],
    );
  }
}
