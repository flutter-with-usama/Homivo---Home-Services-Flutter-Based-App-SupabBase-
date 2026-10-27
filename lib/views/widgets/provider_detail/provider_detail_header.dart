import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/provider_profile_model.dart';

/// Top section of the detail screen.
/// Shows: joined date, service title, avatar logo, tag chips.
class ProviderDetailHeader extends StatelessWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;

  const ProviderDetailHeader({
    super.key,
    required this.provider,
    required this.serviceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Date + avatar row ────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: date + service title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.joinedDate,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider.serviceTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Provider name
                  Text(
                    provider.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: serviceColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right: avatar logo box
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: provider.avatarColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: provider.avatarColor.withValues(alpha: 0.30),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  provider.initials,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: provider.avatarColor,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── Tag chips ────────────────────────────────────────────────────
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: provider.tags
              .map((tag) => _TagChip(label: tag, color: serviceColor))
              .toList(),
        ),
      ],
    );
  }
}

/// Outlined pill chip for tags like "Fulltime", "On-site working", "Hourly".
class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
