import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Floating white card with booking stats.
/// Overlaps the green header by being placed with a negative top margin.
class ProfileStatsRow extends StatelessWidget {
  final int totalBookings;
  final int completedBookings;

  const ProfileStatsRow({
    super.key,
    required this.totalBookings,
    required this.completedBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              value: '$totalBookings',
              label: 'Bookings',
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatChip(
              value: '$completedBookings',
              label: 'Completed',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: const Color(0xFFEEEEEE),
    );
  }
}
