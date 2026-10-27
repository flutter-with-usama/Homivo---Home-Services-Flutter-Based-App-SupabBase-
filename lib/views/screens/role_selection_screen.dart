import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/register_model.dart';
import 'register_screen.dart';

/// Role selection screen — shown when the user taps "Create Account".
/// Lets the user choose Client or Provider before filling the form.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Back button ──────────────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                        color: const Color(0xFFE8E8E8), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Heading ──────────────────────────────────────────────────
              const Text(
                'Join Homivo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'How would you like to use the app?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGrey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // ── Client card ──────────────────────────────────────────────
              _RoleCard(
                role: UserRole.client,
                title: 'I need a Service',
                subtitle:
                    'Book trusted home service professionals for plumbing, '
                    'electrical, cleaning and more.',
                icon: Icons.home_rounded,
                color: AppTheme.primary,
                colorLight: AppTheme.primaryLight,
                features: const [
                  'Browse & book services',
                  'Track professionals in real time',
                  'Manage all your bookings',
                ],
                onTap: () => _navigate(context, UserRole.client),
              ),

              const SizedBox(height: 16),

              // ── Provider card ────────────────────────────────────────────
              _RoleCard(
                role: UserRole.provider,
                title: 'I provide a Service',
                subtitle:
                    'Grow your business by connecting with clients who need '
                    'your skills — on your schedule.',
                icon: Icons.handyman_rounded,
                color: AppTheme.deepPurple,
                colorLight: AppTheme.deepPurpleLight,
                features: const [
                  'Receive job requests',
                  'Manage your schedule',
                  'Track your earnings',
                ],
                onTap: () => _navigate(context, UserRole.provider),
              ),

              const SizedBox(height: 28),

              // ── Already have account ─────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account?  ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(role: role),
      ),
    );
  }
}

// ── Role card ─────────────────────────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color colorLight;
  final List<String> features;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.colorLight,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon + title row ───────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          role == UserRole.client ? 'Client' : 'Provider',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 16,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Subtitle ───────────────────────────────────────────────
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textGrey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 14),

            // ── Feature list ───────────────────────────────────────────
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: color, size: 15),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ── CTA button ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  role == UserRole.client
                      ? 'Sign Up as Client'
                      : 'Sign Up as Provider',
                  style: const TextStyle(
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
    );
  }
}
