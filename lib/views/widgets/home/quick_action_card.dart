import 'package:flutter/material.dart';
import '../../../data/models/home_model.dart';

/// Reusable quick-action card (Book / My Bookings / Manage).
class QuickActionCard extends StatelessWidget {
  final QuickActionModel data;
  final VoidCallback? onTap;

  const QuickActionCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [data.color, data.color.withValues(alpha: 0.78)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: data.color.withValues(alpha: 0.30),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ── Large background icon ────────────────────────────────────
              Positioned(
                bottom: -12,
                right: -12,
                child: Icon(
                  data.icon,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dots decoration — simple Wrap, no GridView
                    _DotsRow(),

                    // Title + subtitle at bottom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w400,
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
      ),
    );
  }
}

/// 3×3 dot decoration using Wrap — no GridView, no unbounded height.
class _DotsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(
          9,
          (_) => Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.50),
            ),
          ),
        ),
      ),
    );
  }
}
