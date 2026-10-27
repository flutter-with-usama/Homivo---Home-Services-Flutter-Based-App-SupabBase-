import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Single profile menu row — coloured icon badge, label, optional subtitle,
/// and a chevron arrow on the right.
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitle,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // ── Icon badge ───────────────────────────────────────
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),

                const SizedBox(width: 14),

                // ── Label + optional subtitle ────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Chevron ──────────────────────────────────────────
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 70,
            endIndent: 16,
            color: Color(0xFFF0F0F0),
          ),
      ],
    );
  }
}
