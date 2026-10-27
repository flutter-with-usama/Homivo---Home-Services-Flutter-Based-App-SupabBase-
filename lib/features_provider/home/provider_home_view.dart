import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/provider_dashboard_model.dart';
import '../../views/widgets/shared/modular_dashboard_card.dart';
import '../../views/widgets/provider/job_request_card.dart';
import 'provider_notifications_screen.dart';
import 'provider_home_provider.dart';
import 'navigation_detail_screen.dart';

/// Provider Home Screen.
/// Stateless — all state lives in [ProviderHomeProvider].
class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: Column(
        children: [
          // ── 1. Green header ──────────────────────────────────────────
          const _ProviderHeader(),

          // ── 2. Scrollable content ────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),

                  // ── Announcement banner ──────────────────────────────
                  // ── Metric cards ─────────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _MetricCardsRow(),
                  ),

                  const SizedBox(height: 26),

                  // ── Active dashboard ─────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _ActiveDashboard(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _ProviderHeader extends StatelessWidget {
  const _ProviderHeader();

  @override
  Widget build(BuildContext context) {
    // Narrow selectors — only rebuild what changes
    final greeting = context.select<ProviderHomeProvider, String>(
      (p) => p.greeting,
    );
    final name = context.select<ProviderHomeProvider, String>(
      (p) => p.providerName,
    );
    final specialty = context.select<ProviderHomeProvider, String>(
      (p) => p.providerSpecialty,
    );
    final notificationCount = context.select<ProviderHomeProvider, int>(
      (p) => p.notificationCount,
    );
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Left: greeting + name + subtitle ──────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.80),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'What is my day looking like?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.70),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Specialty pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        specialty,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProviderNotificationsScreen(),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: -4,
                        top: -5,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: const BoxDecoration(
                            color: AppTheme.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              notificationCount > 9
                                  ? '9+'
                                  : '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Animated Online / Offline toggle ─────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Announcement banner
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Metric cards row — uses shared ModularDashboardCard
// ─────────────────────────────────────────────────────────────────────────────
class _MetricCardsRow extends StatelessWidget {
  const _MetricCardsRow();

  @override
  Widget build(BuildContext context) {
    final earnings = context.select<ProviderHomeProvider, double>(
      (p) => p.earningsToday,
    );
    final jobs = context.select<ProviderHomeProvider, int>(
      (p) => p.jobsCompleted,
    );
    final pending = context.select<ProviderHomeProvider, int>(
      (p) => p.pendingJobs.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Summary",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card 1 — Earnings (Green)
              Expanded(
                child: ModularDashboardCard(
                  label: 'Earnings',
                  value: '\$${earnings.toStringAsFixed(0)}',
                  subtitle: 'completed today',
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppTheme.primary,
                  colorDark: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(width: 10),
              // Card 2 — Jobs (Sky Blue)
              Expanded(
                child: ModularDashboardCard(
                  label: 'Completed',
                  value: '$jobs',
                  subtitle: 'jobs today',
                  icon: Icons.task_alt_rounded,
                  color: AppTheme.skyBlue,
                  colorDark: const Color(0xFF00ACC1),
                ),
              ),
              const SizedBox(width: 10),
              // Card 3 — Pending requests (Deep Purple)
              Expanded(
                child: ModularDashboardCard(
                  label: 'Requests',
                  value: '$pending',
                  subtitle: 'awaiting response',
                  icon: Icons.pending_actions_rounded,
                  color: AppTheme.deepPurple,
                  colorDark: const Color(0xFF5E35B1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Active Dashboard section
// ─────────────────────────────────────────────────────────────────────────────
class _ActiveDashboard extends StatelessWidget {
  const _ActiveDashboard();

  @override
  Widget build(BuildContext context) {
    final activeJob = context.select<ProviderHomeProvider, JobModel?>(
      (p) => p.activeJob,
    );
    final pending = context.select<ProviderHomeProvider, List<JobModel>>(
      (p) => p.pendingJobs,
    );
    final provider = context.read<ProviderHomeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            if (pending.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${pending.length} new',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        // Active job card (high priority)
        if (activeJob != null) ...[
          _ActiveJobCard(
            job: activeJob,
            onComplete: provider.completeActiveJob,
          ),
          const SizedBox(height: 14),
        ],

        // Pending requests
        if (pending.isNotEmpty) ...[
          Text(
            'New Requests',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 10),
          ...pending.map(
            (job) => JobRequestCard(
              job: job,
              onAccept: () => provider.acceptJob(job.id, job.amount),
              onReject: () => provider.rejectJob(job.id),
            ),
          ),
        ],

        // Empty state
        if (activeJob == null && pending.isEmpty) _EmptyDashboard(),
      ],
    );
  }
}

// ── Active job high-priority card ─────────────────────────────────────────────
class _ActiveJobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onComplete;

  const _ActiveJobCard({required this.job, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Color(0xFFEF4444), size: 8),
                      SizedBox(width: 5),
                      Text(
                        'ACTIVE JOB',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEF4444),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (job.amount > 0)
                  Text(
                    '\$${job.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Client info
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: job.serviceColor.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      job.clientAvatar,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: job.serviceColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.clientName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            job.serviceIcon,
                            size: 12,
                            color: job.serviceColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            job.serviceType,
                            style: TextStyle(
                              fontSize: 12,
                              color: job.serviceColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Address
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFF8A8A9A),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    job.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A8A9A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                // Navigate button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NavigationDetailScreen(
                            job: job,
                            onComplete: onComplete,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.navigation_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Navigate',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Mark complete button
                Expanded(
                  child: GestureDetector(
                    onTap: onComplete,
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.40),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Complete',
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
        ),
      ),
    );
  }
}

// ── Empty dashboard state ─────────────────────────────────────────────────────
class _EmptyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 52,
            color: AppTheme.primaryLight,
          ),
          const SizedBox(height: 12),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No active or pending jobs right now.',
            style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
          ),
        ],
      ),
    );
  }
}
