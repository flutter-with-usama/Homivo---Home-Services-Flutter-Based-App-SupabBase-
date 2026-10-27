import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/provider_dashboard_model.dart';

/// Job request card with Accept / Reject buttons for pending jobs,
/// and a status badge for accepted / completed jobs.
class JobRequestCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  const JobRequestCard({
    super.key,
    required this.job,
    this.onAccept,
    this.onReject,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: job.serviceColor.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Coloured top bar ─────────────────────────────────────────
            Container(height: 4, color: job.serviceColor),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Client row ─────────────────────────────────────────
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: job.serviceColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            job.clientAvatar,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: job.serviceColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name + service
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.clientName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  job.serviceIcon,
                                  size: 13,
                                  color: job.serviceColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  job.serviceType,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: job.serviceColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Amount + status badge
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (job.amount > 0)
                            Text(
                              '\$${job.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          const SizedBox(height: 4),
                          _StatusBadge(status: job.status),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Info rows ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: job.address,
                          color: const Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoRow(
                                icon: Icons.calendar_today_outlined,
                                text: job.scheduledDate,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _InfoRow(
                                icon: Icons.access_time_rounded,
                                text: job.scheduledTime,
                                color: const Color(0xFF00B4D8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Action buttons (only for pending) ──────────────────
                  if (job.status == JobStatus.pending) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        // Reject
                        Expanded(
                          child: GestureDetector(
                            onTap: onReject,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Reject',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Accept — direct, no dialog
                        Expanded(
                          child: GestureDetector(
                            onTap: onAccept,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppTheme.primary,
                                    AppTheme.primaryDark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ── Mark complete (only for accepted) ──────────────────
                  if (job.status == JobStatus.accepted) ...[
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: onComplete,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt_rounded,
                              color: AppTheme.primary,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Mark as Complete',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final JobStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg) = switch (status) {
      JobStatus.pending => (
        'New',
        const Color(0xFFF59E0B),
        const Color(0xFFFEF3C7),
      ),
      JobStatus.accepted => ('Active', AppTheme.primary, AppTheme.primaryLight),
      JobStatus.completed => (
        'Done',
        const Color(0xFF00B4D8),
        const Color(0xFFCFF4FC),
      ),
      JobStatus.rejected => (
        'Rejected',
        const Color(0xFFEF4444),
        const Color(0xFFFEE2E2),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
