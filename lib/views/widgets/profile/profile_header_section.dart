import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Green curved header — avatar circle, name, email, phone.
class ProfileHeaderSection extends StatelessWidget {
  final String initials;
  final String fullName;
  final String email;
  final String phone;

  const ProfileHeaderSection({
    super.key,
    required this.initials,
    required this.fullName,
    required this.email,
    required this.phone,
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
          bottomLeft:  Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Column(
            children: [
              // ── Avatar circle ────────────────────────────────────────
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Name ─────────────────────────────────────────────────
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              // ── Email ─────────────────────────────────────────────────
              Text(
                email,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 4),

              // ── Phone ─────────────────────────────────────────────────
              Text(
                phone,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
