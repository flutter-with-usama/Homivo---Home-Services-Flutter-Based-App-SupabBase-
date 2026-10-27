import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Page 1 — Animated house with floating service icons.
class IllustrationPage1 extends StatefulWidget {
  const IllustrationPage1({super.key});

  @override
  State<IllustrationPage1> createState() => _IllustrationPage1State();
}

class _IllustrationPage1State extends State<IllustrationPage1>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _iconCtrl;

  late final Animation<double> _floatAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _iconAnim;

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _floatAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _iconAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnim, _pulseAnim, _iconAnim]),
      builder: (context, _) {
        return SizedBox(
          width: 300,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Background blob ──────────────────────────────────────────
              Positioned(
                top: 30,
                child: Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                ),
              ),

              // ── House (floating) ─────────────────────────────────────────
              Positioned(
                top: 30 - _floatAnim.value,
                child: CustomPaint(
                  size: const Size(180, 180),
                  painter: _HousePainter(),
                ),
              ),

              // ── Service badge: Plumbing ──────────────────────────────────
              Positioned(
                top: 20,
                left: 10,
                child: Transform.scale(
                  scale: _iconAnim.value,
                  child: _ServiceBadge(
                    icon: Icons.water_drop_rounded,
                    label: 'Plumbing',
                    color: const Color(0xFF3B82F6),
                    offset: _floatAnim.value * 0.4,
                  ),
                ),
              ),

              // ── Service badge: Electrical ────────────────────────────────
              Positioned(
                top: 60,
                right: 8,
                child: Transform.scale(
                  scale: _iconAnim.value,
                  child: _ServiceBadge(
                    icon: Icons.bolt_rounded,
                    label: 'Electrical',
                    color: const Color(0xFFF59E0B),
                    offset: -_floatAnim.value * 0.5,
                  ),
                ),
              ),

              // ── Service badge: Cleaning ──────────────────────────────────
              Positioned(
                bottom: 20,
                left: 20,
                child: Transform.scale(
                  scale: _iconAnim.value,
                  child: _ServiceBadge(
                    icon: Icons.cleaning_services_rounded,
                    label: 'Cleaning',
                    color: AppTheme.primary,
                    offset: _floatAnim.value * 0.3,
                  ),
                ),
              ),

              // ── Service badge: Painting ──────────────────────────────────
              Positioned(
                bottom: 30,
                right: 10,
                child: Transform.scale(
                  scale: _iconAnim.value,
                  child: _ServiceBadge(
                    icon: Icons.format_paint_rounded,
                    label: 'Painting',
                    color: const Color(0xFFEC4899),
                    offset: -_floatAnim.value * 0.6,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── House painter ────────────────────────────────────────────────────────────
class _HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12 + 4, h * 0.44 + 6, w * 0.76, h * 0.50),
        const Radius.circular(14),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.10),
    );

    // Roof
    final roofPath = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..lineTo(w * 0.88, h * 0.44)
      ..lineTo(w * 0.12, h * 0.44)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = AppTheme.primaryDark);
    canvas.drawPath(
      roofPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Chimney
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.62, h * 0.12, w * 0.10, h * 0.20),
        const Radius.circular(3),
      ),
      Paint()..color = AppTheme.primaryDark,
    );

    // Walls
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.44, w * 0.76, h * 0.50),
        const Radius.circular(14),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.44, w * 0.76, h * 0.50),
        const Radius.circular(14),
      ),
      Paint()
        ..color = AppTheme.primary.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.40, h * 0.64, w * 0.20, h * 0.30),
        const Radius.circular(8),
      ),
      Paint()..color = AppTheme.primary,
    );
    // Door knob
    canvas.drawCircle(
      Offset(w * 0.57, h * 0.79),
      3,
      Paint()..color = Colors.white,
    );

    // Left window
    _drawWindow(canvas, Rect.fromLTWH(w * 0.18, h * 0.52, w * 0.18, h * 0.18));
    // Right window
    _drawWindow(canvas, Rect.fromLTWH(w * 0.64, h * 0.52, w * 0.18, h * 0.18));
  }

  void _drawWindow(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      Paint()..color = const Color(0xFFBFEFD7),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      Paint()
        ..color = AppTheme.primary.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    // Cross divider
    final midX = rect.left + rect.width / 2;
    final midY = rect.top + rect.height / 2;
    final divPaint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(midX, rect.top), Offset(midX, rect.bottom), divPaint);
    canvas.drawLine(Offset(rect.left, midY), Offset(rect.right, midY), divPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Service badge chip ────────────────────────────────────────────────────────
class _ServiceBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double offset;

  const _ServiceBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
