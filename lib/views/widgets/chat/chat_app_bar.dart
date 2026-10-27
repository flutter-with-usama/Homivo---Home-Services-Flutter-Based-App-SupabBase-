import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Chat screen app bar — back arrow, avatar with online dot, name, menu icon.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String initials;
  final Color avatarColor;
  final bool isOnline;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.initials,
    required this.avatarColor,
    this.isOnline = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 15,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          // ── Avatar with online dot ───────────────────────────────────
          Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: avatarColor,
                    ),
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 10),

          // ── Name + status ────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isOnline ? AppTheme.primary : AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // ── Three-dot menu ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              ),
              child: const Icon(
                Icons.more_vert_rounded,
                size: 18,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}
