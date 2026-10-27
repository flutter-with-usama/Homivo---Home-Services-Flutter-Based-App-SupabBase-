import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/provider_profile_model.dart';

/// Top card showing provider avatar, name, service title and price range.
class BookingProviderCard extends StatelessWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;

  const BookingProviderCard({
    super.key,
    required this.provider,
    required this.serviceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          // ── Avatar ──────────────────────────────────────────────────
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: provider.avatarColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                provider.initials,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: provider.avatarColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ── Name + service + price ───────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  provider.serviceTitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.priceRange,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: serviceColor,
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
