import 'package:flutter/material.dart';

/// Standalone logout row — red icon badge + "Logout" label, no chevron.
class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileLogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Red icon badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
