import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/provider_dashboard_model.dart';

/// Shows the client's address and lets the provider mark the job complete.
class NavigationDetailScreen extends StatelessWidget {
  final JobModel job;
  final VoidCallback onComplete;

  const NavigationDetailScreen({
    super.key,
    required this.job,
    required this.onComplete,
  });

  /// Splits "street , city" into a street part and a city part.
  /// If no comma is found, the whole string is treated as the street.
  (String street, String city) _splitAddress(String address) {
    final parts = address.split(',');
    if (parts.length >= 2) {
      return (parts.first.trim(), parts.sublist(1).join(',').trim());
    }
    return (address.trim(), '');
  }

  @override
  Widget build(BuildContext context) {
    final (street, city) = _splitAddress(job.address);

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          _Header(job: job),

          // ── Scrollable body ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Client info card ──────────────────────────────────
                  _ClientInfoCard(job: job),
                  const SizedBox(height: 24),

                  // ── Address card ──────────────────────────────────────
                  _AddressCard(street: street, city: city),
                  const SizedBox(height: 24),

                  // ── Job details ───────────────────────────────────────
                  _JobDetailsCard(job: job),
                ],
              ),
            ),
          ),

          // ── Bottom action buttons ────────────────────────────────────
          _BottomActionButtons(
            job: job,
            onComplete: () {
              onComplete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final JobModel job;
  const _Header({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Navigate to Client',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  job.serviceType,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.80),
                  ),
                ),
              ],
            ),
          ),
          // Amount badge
          if (job.amount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '\$${job.amount.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Client info card
// ─────────────────────────────────────────────────────────────────────────────
class _ClientInfoCard extends StatelessWidget {
  final JobModel job;
  const _ClientInfoCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: job.serviceColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                job.clientAvatar,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: job.serviceColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.clientName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(job.serviceIcon, size: 13, color: job.serviceColor),
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
          // Active job badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Color(0xFFEF4444), size: 7),
                SizedBox(width: 4),
                Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEF4444),
                    letterSpacing: 0.6,
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

// ─────────────────────────────────────────────────────────────────────────────
// Address card
// ─────────────────────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final String street;
  final String city;

  const _AddressCard({required this.street, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Client Address',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.70),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Street address
          _AddressRow(
            icon: Icons.home_outlined,
            label: 'Street',
            value: street.isNotEmpty ? street : '—',
          ),

          if (city.isNotEmpty) ...[
            const SizedBox(height: 14),
            _divider(),
            const SizedBox(height: 14),

            // City
            _AddressRow(
              icon: Icons.location_city_rounded,
              label: 'City',
              value: city,
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(height: 1, color: Colors.white.withValues(alpha: 0.10));
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AddressRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.50)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.50),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Job details card
// ─────────────────────────────────────────────────────────────────────────────
class _JobDetailsCard extends StatelessWidget {
  final JobModel job;
  const _JobDetailsCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Details',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: job.scheduledDate,
          ),
          const SizedBox(height: 10),
          _DetailRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: job.scheduledTime,
          ),
          const SizedBox(height: 10),
          _DetailRow(
            icon: Icons.attach_money_rounded,
            label: 'Amount',
            value: '\$${job.amount.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF8A8A9A),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '—',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Complete button
// ─────────────────────────────────────────────────────────────────────────────
class _BottomActionButtons extends StatelessWidget {
  final VoidCallback onComplete;

  const _BottomActionButtons({required this.job, required this.onComplete});

  // job param kept for API compatibility but not used in UI
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgPage,
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: onComplete,
          icon: const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
          label: Text(
            'Complete',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
