import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Auto-scrolling promotional announcement banner.
class PromoBanner extends StatefulWidget {
  final List<String> promos;

  const PromoBanner({super.key, required this.promos});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _current = (_current + 1) % widget.promos.length;
      });
      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Megaphone icon ───────────────────────────────────────────────
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // ── Animated promo text ──────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Text(
                widget.promos[_current],
                key: ValueKey(_current),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ── Scroll arrows ────────────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_up_rounded,
                  size: 14, color: AppTheme.textGrey),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 14, color: AppTheme.textGrey),
            ],
          ),
        ],
      ),
    );
  }
}
