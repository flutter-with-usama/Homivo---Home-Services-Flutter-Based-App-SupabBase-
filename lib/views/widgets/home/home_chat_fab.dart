import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Floating chat / support button fixed at bottom-right.
class HomeChatFab extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeChatFab({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
