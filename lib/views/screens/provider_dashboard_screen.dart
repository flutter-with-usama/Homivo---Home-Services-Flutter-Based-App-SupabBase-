import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/provider_dashboard_model.dart';
import '../../viewmodels/provider_dashboard_viewmodel.dart';
import '../widgets/home/section_title.dart';
import '../widgets/provider/earnings_summary_card.dart';
import '../widgets/provider/job_request_card.dart';
import '../widgets/provider/provider_bottom_nav.dart';
import '../widgets/provider/provider_header_section.dart';
import '../widgets/provider/stats_row_widget.dart';
import 'messages_screen.dart';

class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final vm = context.watch<ProviderDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      bottomNavigationBar: ProviderBottomNav(
        selectedIndex: vm.selectedNavIndex,
        onTap: vm.onNavTap,
      ),
      body: switch (vm.selectedNavIndex) {
        // ── 0: Home — job overview with header ──────────────────────────────
        0 => Column(
          children: [
            ProviderHeaderSection(
              greeting: vm.greeting,
              providerName: vm.providerName,
              specialty: vm.providerSpecialty,
            ),
            Expanded(child: _HomeTab(vm: vm)),
          ],
        ),
        // ── 1: Messages ──────────────────────────────────────────────────────
        1 => const MessagesScreen(),
        // ── 2: Dashboard ─────────────────────────────────────────────────────
        2 => Column(
          children: [
            ProviderHeaderSection(
              greeting: vm.greeting,
              providerName: vm.providerName,
              specialty: vm.providerSpecialty,
            ),
            Expanded(child: _DashboardTab(vm: vm)),
          ],
        ),
        // ── 3: Profile ───────────────────────────────────────────────────────
        3 => Column(
          children: [
            ProviderHeaderSection(
              greeting: vm.greeting,
              providerName: vm.providerName,
              specialty: vm.providerSpecialty,
            ),
            Expanded(child: _ProfileTab(vm: vm)),
          ],
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// ── Home Tab (index 0) — pending & active jobs overview ──────────────────────
class _HomeTab extends StatelessWidget {
  final ProviderDashboardViewModel vm;
  const _HomeTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    final pending = vm.pendingJobs;
    final active = vm.activeJobs;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ── Earnings card ──────────────────────────────────────────
          EarningsSummaryCard(earnings: vm.earnings),

          const SizedBox(height: 20),

          // ── Stats row ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StatsRowWidget(
              activeJobs: vm.earnings.activeJobs,
              pendingJobs: vm.earnings.pendingJobs,
              completedJobs: vm.earnings.completedJobs,
            ),
          ),

          const SizedBox(height: 24),

          // ── New requests ───────────────────────────────────────────
          if (pending.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: 'New Requests (${pending.length})',
                // "See All" navigates to Dashboard tab (index 2)
                onSeeAll: pending.length > 2 ? () => vm.onNavTap(2) : null,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: pending
                    .take(2)
                    .map(
                      (job) => JobRequestCard(
                        job: job,
                        onAccept: () => vm.acceptJob(job.id, job.amount),
                        onReject: () => vm.rejectJob(job.id),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],

          // ── Active jobs ────────────────────────────────────────────
          if (active.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(title: 'Active Jobs (${active.length})'),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: active
                    .map(
                      (job) => JobRequestCard(
                        job: job,
                        onComplete: () => vm.completeJob(job.id),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],

          // ── Empty state ────────────────────────────────────────────
          if (pending.isEmpty && active.isEmpty)
            const _EmptyState(
              icon: Icons.check_circle_outline_rounded,
              message: 'All caught up!\nNo pending or active jobs.',
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Dashboard Tab (index 2) — all jobs + earnings ─────────────────────────────
class _DashboardTab extends StatelessWidget {
  final ProviderDashboardViewModel vm;
  const _DashboardTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    final all = vm.allJobs
        .where((j) => j.status != JobStatus.rejected)
        .toList();
    final completed = vm.completedJobs;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EarningsSummaryCard(earnings: vm.earnings),
          const SizedBox(height: 24),
          SectionTitle(title: 'All Jobs (${all.length})'),
          const SizedBox(height: 14),
          if (all.isEmpty)
            const _EmptyState(
              icon: Icons.work_off_outlined,
              message: 'No jobs yet.',
            )
          else
            ...all.map(
              (job) => JobRequestCard(
                job: job,
                onAccept: job.status == JobStatus.pending
                    ? () => vm.acceptJob(job.id, job.amount)
                    : null,
                onReject: job.status == JobStatus.pending
                    ? () => vm.rejectJob(job.id)
                    : null,
                onComplete: job.status == JobStatus.accepted
                    ? () => vm.completeJob(job.id)
                    : null,
              ),
            ),
          if (completed.isNotEmpty) ...[
            const SizedBox(height: 24),
            SectionTitle(title: 'Completed Jobs (${completed.length})'),
            const SizedBox(height: 14),
            ...completed.map((job) => JobRequestCard(job: job)),
          ],
        ],
      ),
    );
  }
}

// ── Profile Tab ───────────────────────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  final ProviderDashboardViewModel vm;
  const _ProfileTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'JW',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            vm.providerName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vm.providerSpecialty,
            style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 28),

          StatsRowWidget(
            activeJobs: vm.earnings.activeJobs,
            pendingJobs: vm.earnings.pendingJobs,
            completedJobs: vm.earnings.completedJobs,
          ),

          const SizedBox(height: 24),

          ...[
            (Icons.edit_outlined, 'Edit Profile'),
            (Icons.lock_outline_rounded, 'Change Password'),
            (Icons.notifications_outlined, 'Notifications'),
            (Icons.help_outline_rounded, 'Help & Support'),
            (Icons.logout_rounded, 'Log Out'),
          ].map(
            (item) => _ProfileMenuItem(
              icon: item.$1,
              label: item.$2,
              onTap: item.$2 == 'Log Out'
                  ? () async {
                      await vm.logout();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil('/login', (_) => false);
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ProfileMenuItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLogout = label == 'Log Out';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isLogout ? const Color(0xFFFEE2E2) : AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isLogout ? const Color(0xFFEF4444) : AppTheme.primary,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF1A1A2E),
          ),
        ),
        trailing: isLogout
            ? null
            : const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textGrey,
                size: 20,
              ),
        onTap: onTap,
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(icon, size: 56, color: AppTheme.primaryLight),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textGrey,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
