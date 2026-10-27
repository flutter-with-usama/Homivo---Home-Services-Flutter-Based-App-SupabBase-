import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// "Job Description" section — title, paragraph, bullet list with green ticks.
class JobDescriptionSection extends StatelessWidget {
  final String description;
  final List<String> highlights;

  const JobDescriptionSection({
    super.key,
    required this.description,
    required this.highlights,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title ────────────────────────────────────────────────
        const Text(
          'Job Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),

        const SizedBox(height: 12),

        // ── Description paragraph ────────────────────────────────────────
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textGrey,
            height: 1.65,
          ),
        ),

        const SizedBox(height: 16),

        // ── Bullet highlights ────────────────────────────────────────────
        ...highlights.map((point) => _BulletPoint(text: point)),
      ],
    );
  }
}

/// Single bullet point with a green tick icon.
class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.primary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
