import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/provider_dashboard_model.dart';

/// Earnings summary card — total, this week, this month.
class EarningsSummaryCard extends StatelessWidget {
  final EarningsSummaryModel earnings;

  const EarningsSummaryCard({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Earnings',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'All Time',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── Total amount ───────────────────────────────────────────────
          Text(
            '\$${earnings.totalEarnings.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 16),

          // ── Divider ────────────────────────────────────────────────────
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.10),
          ),

          const SizedBox(height: 16),

          // ── This week / This month ─────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _EarningsChip(
                  label: 'This Week',
                  amount: earnings.thisWeek,
                  icon: Icons.trending_up_rounded,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _EarningsChip(
                  label: 'This Month',
                  amount: earnings.thisMonth,
                  icon: Icons.calendar_month_rounded,
                  color: const Color(0xFF00B4D8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EarningsChip extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _EarningsChip({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.60),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '\$${amount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
