import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Section divider — "Today", "Yesterday", "Earlier".
class NotificationGroupHeader extends StatelessWidget {
  final String label;
  final int count;

  const NotificationGroupHeader({
    super.key,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFF0F0F0),
            ),
          ),
        ],
      ),
    );
  }
}
