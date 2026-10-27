import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class BookingStatusCard extends StatelessWidget {
  final String status;

  const BookingStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, message, color, background) = switch (status) {
      'accepted' => (
        'Confirmed',
        'Your provider accepted this request.',
        AppTheme.primary,
        AppTheme.primaryLight,
      ),
      'completed' => (
        'Completed',
        'This service has been marked as completed.',
        const Color(0xFF00B4D8),
        const Color(0xFFCFF4FC),
      ),
      'rejected' => (
        'Cancelled',
        'The provider could not accept this request.',
        const Color(0xFFEF4444),
        const Color(0xFFFEE2E2),
      ),
      _ => (
        'Pending',
        'Waiting for the provider to review your request.',
        const Color(0xFFF59E0B),
        const Color(0xFFFEF3C7),
      ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(message, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
