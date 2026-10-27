import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Bottom input bar — rounded text field + green send button.
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ChatInputBar({super.key, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    widget.onSend(_ctrl.text);
    _ctrl.clear();
    setState(() => _hasText = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Text field ─────────────────────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FA),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFE8E8E8),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _ctrl,
                  onChanged: (v) =>
                      setState(() => _hasText = v.trim().isNotEmpty),
                  onSubmitted: (_) => _send(),
                  textInputAction: TextInputAction.send,
                  maxLines: 4,
                  minLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type message...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textGrey,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ── Send button ────────────────────────────────────────────
            GestureDetector(
              onTap: _send,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hasText ? AppTheme.primary : const Color(0xFFE0E0E0),
                  boxShadow: _hasText
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.40),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: _hasText ? Colors.white : AppTheme.textGrey,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
