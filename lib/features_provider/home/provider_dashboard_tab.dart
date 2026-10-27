import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/provider_dashboard_model.dart';
import '../../viewmodels/provider_dashboard_viewmodel.dart';
import '../../views/widgets/home/section_title.dart';
import '../../views/widgets/provider/earnings_summary_card.dart';
import '../../views/widgets/provider/job_request_card.dart';
import '../../views/widgets/provider/provider_header_section.dart';
import '../../views/widgets/provider/stats_row_widget.dart';

/// Dashboard tab — shows earnings summary, all jobs, and completed jobs.
class ProviderDashboardTab extends StatelessWidget {
  const ProviderDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final vm = context.watch<ProviderDashboardViewModel>();

    final all = vm.allJobs
        .where((j) => j.status != JobStatus.rejected)
        .toList();
    final completed = vm.completedJobs;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        children: [
          // ── Green curved header ──────────────────────────────────────
          ProviderHeaderSection(
            greeting: vm.greeting,
            providerName: vm.providerName,
            specialty: vm.providerSpecialty,
          ),

          // ── Scrollable content ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Earnings summary
                  EarningsSummaryCard(earnings: vm.earnings),
                  const SizedBox(height: 20),

                  // Stats row
                  StatsRowWidget(
                    activeJobs: vm.earnings.activeJobs,
                    pendingJobs: vm.earnings.pendingJobs,
                    completedJobs: vm.earnings.completedJobs,
                  ),
                  const SizedBox(height: 24),

                  // All jobs
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

                  // Completed jobs
                  if (completed.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    SectionTitle(title: 'Completed Jobs (${completed.length})'),
                    const SizedBox(height: 14),
                    ...completed.map((job) => JobRequestCard(job: job)),
                  ],
                ],
              ),
            ),
          ),
        ],
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
