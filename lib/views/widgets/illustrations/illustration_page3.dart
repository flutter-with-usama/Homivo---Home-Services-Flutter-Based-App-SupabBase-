import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Page 3 — Animated schedule calendar with recurring service cards.
class IllustrationPage3 extends StatefulWidget {
  const IllustrationPage3({super.key});

  @override
  State<IllustrationPage3> createState() => _IllustrationPage3State();
}

class _IllustrationPage3State extends State<IllustrationPage3>
    with TickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final AnimationController _checkCtrl;
  late final AnimationController _floatCtrl;

  late final List<Animation<Offset>> _slideAnims;
  late final Animation<double> _checkAnim;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Staggered slide-in for 3 cards
    _slideAnims = List.generate(3, (i) {
      return Tween<Offset>(
        begin: const Offset(0.6, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _slideCtrl,
          curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeOutCubic),
        ),
      );
    });

    _checkAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut),
    );

    _floatAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // Delay check animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _checkCtrl.forward();
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _checkCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  static const _cards = [
    _CardData(
      icon: Icons.cleaning_services_rounded,
      title: 'Deep Cleaning',
      subtitle: 'Every Monday',
      color: Color(0xFF3B82F6),
    ),
    _CardData(
      icon: Icons.grass_rounded,
      title: 'Garden Care',
      subtitle: 'Every Friday',
      color: Color(0xFF10B981),
    ),
    _CardData(
      icon: Icons.pest_control_rounded,
      title: 'Pest Control',
      subtitle: 'Monthly',
      color: Color(0xFFF59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideCtrl, _checkAnim, _floatAnim]),
      builder: (context, _) {
        return SizedBox(
          width: 300,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Background blob ──────────────────────────────────────────
              Positioned(
                top: 20,
                child: Transform.translate(
                  offset: Offset(0, _floatAnim.value * 0.3),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
              ),

              // ── Calendar header ──────────────────────────────────────────
              Positioned(
                top: 16,
                child: Transform.translate(
                  offset: Offset(0, -_floatAnim.value * 0.5),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'May 2026',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '3 services scheduled',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        // Mini calendar dots
                        Row(
                          children: List.generate(
                            5,
                            (i) => Container(
                              margin: const EdgeInsets.only(left: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i < 3
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Service cards (staggered) ────────────────────────────────
              Positioned(
                top: 90,
                left: 20,
                right: 20,
                child: Column(
                  children: List.generate(_cards.length, (i) {
                    return SlideTransition(
                      position: _slideAnims[i],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ScheduleCard(
                          data: _cards[i],
                          isChecked: i == 0,
                          checkScale: i == 0 ? _checkAnim.value : 0,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _CardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _ScheduleCard extends StatelessWidget {
  final _CardData data;
  final bool isChecked;
  final double checkScale;

  const _ScheduleCard({
    required this.data,
    required this.isChecked,
    required this.checkScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: data.color.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          const SizedBox(width: 10),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          // Check badge
          Transform.scale(
            scale: checkScale,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isChecked ? AppTheme.primary : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: isChecked ? Colors.white : Colors.grey,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
