import 'package:flutter/material.dart';

/// Shared, role-agnostic metric card used by both client and provider dashboards.
///
/// Renders a coloured gradient card with:
/// - A faint background decoration icon
/// - A 3×3 dot-grid accent (top-left)
/// - A labelled metric value
/// - An optional subtitle
///
/// All visual properties are injected — the card has zero business logic.
class ModularDashboardCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Color colorDark;
  final VoidCallback? onTap;

  const ModularDashboardCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.colorDark,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, colorDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.32),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ── Faint background icon ──────────────────────────────────
              Positioned(
                bottom: -12,
                right: -12,
                child: Icon(
                  icon,
                  size: 88,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),

              // ── Dot-grid accent ────────────────────────────────────────
              Positioned(
                top: 10,
                left: 10,
                child: _DotGrid(),
              ),

              // ── Content ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Dot grid spacer so content starts below the dots
                    const SizedBox(height: 28),

                    // Icon badge
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),

                    const SizedBox(height: 10),

                    // Value
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Label
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Optional subtitle
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 3×3 dot-grid decoration — shared visual language across all dashboard cards.
class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(
          9,
          (_) => Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}
