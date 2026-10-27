import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../screens/client_profile_screen.dart';
import '../../screens/notifications_screen.dart';

/// Green curved header — greeting, user name, notification + avatar.
class HomeHeaderSection extends StatelessWidget {
  final String greeting;
  final String userName;

  const HomeHeaderSection({
    super.key,
    required this.greeting,
    required this.userName,
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
              // ── Greeting + name ──────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Notification icon ────────────────────────────────────────
              _HeaderIconButton(
                icon: Icons.notifications_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ── Avatar — taps to profile ─────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClientProfileScreen(),
                  ),
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.25),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 26,
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

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

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
