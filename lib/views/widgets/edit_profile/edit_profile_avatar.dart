import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Avatar section — shows initials circle with a green camera badge.
class EditProfileAvatar extends StatelessWidget {
  final String initials;
  final bool isProvider;

  const EditProfileAvatar({
    super.key,
    required this.initials,
    required this.isProvider,
  });

  @override
  Widget build(BuildContext context) {
    final color = isProvider ? AppTheme.deepPurple : AppTheme.primary;

    return Column(
      children: [
        Stack(
          children: [
            // ── Avatar circle ──────────────────────────────────────────
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ── Camera badge ───────────────────────────────────────────
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: color,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Tap to change photo',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: isProvider
                ? AppTheme.deepPurpleLight
                : AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isProvider ? 'Provider Account' : 'Client Account',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
