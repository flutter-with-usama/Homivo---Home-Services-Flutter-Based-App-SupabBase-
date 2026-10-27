import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

/// Homivo top logo + brand name.
class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Icon mark ─────────────────────────────────────────────────────
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.home_rounded, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 10),
        // ── Word mark — explicit Poppins (RichText bypasses theme) ────────
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Homi',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'vo',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
