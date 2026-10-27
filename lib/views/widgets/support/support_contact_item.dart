import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Reusable contact row — icon badge, title, subtitle, arrow.
/// Used for Email, WhatsApp, Phone, Live Chat options.
class SupportContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;
  final bool showDivider;

  const SupportContactItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
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
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // ── Icon badge ─────────────────────────────────────────
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),

                const SizedBox(width: 14),

                // ── Title + subtitle ───────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Arrow ──────────────────────────────────────────────
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 76,
            endIndent: 16,
            color: Color(0xFFF0F0F0),
          ),
      ],
    );
  }
}
