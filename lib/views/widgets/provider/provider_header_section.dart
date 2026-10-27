import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features_provider/home/provider_notifications_screen.dart';

/// Green curved header for the provider dashboard.
/// Shows greeting, provider name, specialty, notification + avatar.
class ProviderHeaderSection extends StatelessWidget {
  final String greeting;
  final String providerName;
  final String specialty;

  const ProviderHeaderSection({
    super.key,
    required this.greeting,
    required this.providerName,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
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
              // ── Greeting + name + specialty ──────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      providerName,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Specialty
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              specialty,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Notification icon ────────────────────────────────────────
              _IconBtn(
                icon: Icons.notifications_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProviderNotificationsScreen(),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ── Avatar ───────────────────────────────────────────────────
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.25),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    'JW',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
