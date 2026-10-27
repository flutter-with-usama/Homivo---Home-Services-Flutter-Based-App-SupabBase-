import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/provider_profile_model.dart';

/// Provider profile list tile — matches the UI screenshot.
/// Shows: avatar, joined date, service title, price range, location, status.
class ProviderListTile extends StatelessWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;
  final VoidCallback? onTap;

  const ProviderListTile({
    super.key,
    required this.provider,
    required this.serviceColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: serviceColor.withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ─────────────────────────────────────────────────
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
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: provider.avatarColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Details ────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date + status row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          provider.joinedDate,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textGrey,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(status: provider.status),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Provider name
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Service title
                  Text(
                    provider.serviceTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: serviceColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // Price + location row
                  Row(
                    children: [
                      // Price
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on_outlined,
                                size: 15, color: AppTheme.primary),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                provider.priceRange,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Location
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.work_outline_rounded,
                                size: 15, color: AppTheme.primary),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                provider.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Experience row
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 13, color: AppTheme.textGrey),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          provider.experience,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final ProviderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ProviderStatus.available => ('Available', AppTheme.primary),
      ProviderStatus.busy      => ('Busy', const Color(0xFFF59E0B)),
      ProviderStatus.completed => ('Completed', const Color(0xFF00B4D8)),
    };

    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
