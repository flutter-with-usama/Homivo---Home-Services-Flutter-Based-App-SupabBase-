import 'package:flutter/material.dart';

/// Title + description text block for each onboarding page.
class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Title ──────────────────────────────────────────────────────────
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),
        // ── Description ────────────────────────────────────────────────────
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Color(0xFF8A8A9A),
          ),
        ),
      ],
    );
  }
}
