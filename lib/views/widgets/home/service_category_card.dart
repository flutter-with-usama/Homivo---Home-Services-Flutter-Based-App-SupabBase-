import 'package:flutter/material.dart';
import '../../../data/models/home_model.dart';

/// Service card — vertical layout: icon top, name + arrow bottom.
/// No horizontal content competition → zero overflow risk.
class ServiceCategoryCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceCategoryCard({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: service.color.withValues(alpha: 0.13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top colour bar ───────────────────────────────────────
              Container(height: 4, color: service.color),

              // ── Body ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _ServiceLogo(service: service)),

                    const SizedBox(height: 12),

                    // Service name — full width, one line, never clips
                    Text(
                      service.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Book now row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Book now',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: service.color,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 11,
                          color: service.color,
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

class _ServiceLogo extends StatelessWidget {
  final ServiceModel service;

  const _ServiceLogo({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FBFA), Color(0xFFEAF9F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 13,
            child: Container(
              width: 46,
              height: 12,
              decoration: BoxDecoration(
                color: service.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.18,
            child: Container(
              width: 42,
              height: 34,
              decoration: BoxDecoration(
                color: service.color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFBDF3DD).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: service.color.withValues(alpha: 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(service.icon, color: service.color, size: 28),
          ),
          Positioned(
            right: 17,
            top: 17,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
