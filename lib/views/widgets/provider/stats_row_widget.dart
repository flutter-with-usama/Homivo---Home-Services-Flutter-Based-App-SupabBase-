import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 3 mini stat chips: Active Jobs / Pending / Completed.
class StatsRowWidget extends StatelessWidget {
  final int activeJobs;
  final int pendingJobs;
  final int completedJobs;

  const StatsRowWidget({
    super.key,
    required this.activeJobs,
    required this.pendingJobs,
    required this.completedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            label: 'Active',
            count: activeJobs,
            color: AppTheme.primary,
            bgColor: AppTheme.primaryLight,
            icon: Icons.play_circle_outline_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            label: 'Pending',
            count: pendingJobs,
            color: const Color(0xFFF59E0B),
            bgColor: const Color(0xFFFEF3C7),
            icon: Icons.hourglass_empty_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            label: 'Done',
            count: completedJobs,
            color: const Color(0xFF00B4D8),
            bgColor: const Color(0xFFCFF4FC),
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
