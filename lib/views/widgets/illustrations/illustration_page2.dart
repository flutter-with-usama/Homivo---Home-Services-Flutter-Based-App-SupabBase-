import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Page 2 — Animated live-tracking map with moving pro marker.
class IllustrationPage2 extends StatefulWidget {
  const IllustrationPage2({super.key});

  @override
  State<IllustrationPage2> createState() => _IllustrationPage2State();
}

class _IllustrationPage2State extends State<IllustrationPage2>
    with TickerProviderStateMixin {
  late final AnimationController _moveCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _fadeCtrl;

  late final Animation<double> _moveAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _moveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _moveAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _moveCtrl, curve: Curves.easeInOut),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _moveCtrl.dispose();
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_moveAnim, _pulseAnim, _fadeAnim]),
      builder: (context, _) {
        // Pro marker moves along a curved path
        final t = _moveAnim.value;
        final markerX = 60 + t * 130.0;
        final markerY = 160 - math.sin(t * math.pi) * 60;

        return FadeTransition(
          opacity: _fadeAnim,
          child: SizedBox(
            width: 300,
            height: 280,
            child: Stack(
              children: [
                // ── Map card ───────────────────────────────────────────────
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomPaint(
                        painter: _MapGridPainter(),
                      ),
                    ),
                  ),
                ),

                // ── Route path ────────────────────────────────────────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RoutePainter(progress: t),
                  ),
                ),

                // ── Destination pin ───────────────────────────────────────
                Positioned(
                  left: 168,
                  top: 88,
                  child: _MapPin(
                    color: const Color(0xFFEF4444),
                    icon: Icons.home_rounded,
                    size: 36,
                  ),
                ),

                // ── Pulse ring around destination ─────────────────────────
                Positioned(
                  left: 168 - (_pulseAnim.value * 18 - 18),
                  top: 88 - (_pulseAnim.value * 18 - 18),
                  child: Opacity(
                    opacity: (1 - (_pulseAnim.value - 1) / 1.2).clamp(0, 1),
                    child: Container(
                      width: 36 + (_pulseAnim.value - 1) * 36,
                      height: 36 + (_pulseAnim.value - 1) * 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEF4444),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Moving pro marker ─────────────────────────────────────
                Positioned(
                  left: markerX + 16,
                  top: markerY - 10,
                  child: _ProMarker(),
                ),

                // ── ETA chip ──────────────────────────────────────────────
                Positioned(
                  bottom: 28,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: AppTheme.primary, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Arriving in ${(8 - (t * 6).round())} min',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Map grid background ───────────────────────────────────────────────────────
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.07)
      ..strokeWidth = 1;

    // Horizontal roads
    for (double y = 40; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical roads
    for (double x = 40; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Road highlights
    final roadPaint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.12)
      ..strokeWidth = 8;
    canvas.drawLine(
        Offset(0, size.height * 0.55), Offset(size.width, size.height * 0.55), roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.45, 0), Offset(size.width * 0.45, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Animated route path ───────────────────────────────────────────────────────
class _RoutePainter extends CustomPainter {
  final double progress;
  _RoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(76, 176)
      ..cubicTo(100, 176, 140, 120, 186, 106);

    final metrics = path.computeMetrics().first;
    final drawn = metrics.extractPath(0, metrics.length * progress);

    canvas.drawPath(
      drawn,
      Paint()
        ..color = AppTheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dashed remaining path
    final remaining =
        metrics.extractPath(metrics.length * progress, metrics.length);
    canvas.drawPath(
      remaining,
      Paint()
        ..color = AppTheme.primary.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) => old.progress != progress;
}

// ── Map pin ───────────────────────────────────────────────────────────────────
class _MapPin extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;

  const _MapPin({required this.color, required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.55),
        ),
        CustomPaint(
          size: const Size(10, 8),
          painter: _PinTailPainter(color: color),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Pro avatar marker ─────────────────────────────────────────────────────────
class _ProMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppTheme.primary, width: 2),
      ),
      child: const CircleAvatar(
        radius: 14,
        backgroundColor: AppTheme.primaryLight,
        child: Icon(Icons.person_rounded, color: AppTheme.primary, size: 18),
      ),
    );
  }
}
