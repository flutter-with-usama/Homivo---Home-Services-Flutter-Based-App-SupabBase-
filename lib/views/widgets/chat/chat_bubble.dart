import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/chat_message_model.dart';

/// A single chat bubble — green on the right (mine), cream on the left (theirs).
/// Timestamp sits below the bubble, aligned to the same side.
class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // ── Bubble ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment:
                isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMine) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMine
                        ? AppTheme.primary
                        : const Color(0xFFF5EFE0), // warm cream
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMine ? 18 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMine
                            ? AppTheme.primary.withValues(alpha: 0.20)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: isMine
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              if (isMine) const SizedBox(width: 8),
            ],
          ),

          // ── Timestamp ────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isMine ? 0 : 12,
              right: isMine ? 12 : 0,
            ),
            child: Text(
              message.time,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
