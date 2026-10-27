import 'package:flutter/material.dart';

/// Visual password strength indicator — 4 segments that fill as strength grows.
/// Strength levels: Weak (1) · Fair (2) · Good (3) · Strong (4)
class PasswordStrengthBar extends StatelessWidget {
  final String password;
  final Color accentColor;

  const PasswordStrengthBar({
    super.key,
    required this.password,
    required this.accentColor,
  });

  // ── Strength calculation ───────────────────────────────────────────────────
  static int _score(String p) {
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8)                                    score++;
    if (RegExp(r'[A-Z]').hasMatch(p))                     score++;
    if (RegExp(r'[0-9]').hasMatch(p))                     score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p))  score++;
    return score;
  }

  static String _label(int score) => switch (score) {
        0 => '',
        1 => 'Weak',
        2 => 'Fair',
        3 => 'Good',
        _ => 'Strong',
      };

  static Color _color(int score, Color accent) => switch (score) {
        0 => Colors.transparent,
        1 => const Color(0xFFEF4444),
        2 => const Color(0xFFF59E0B),
        3 => const Color(0xFF00B4D8),
        _ => accent,
      };

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final score = _score(password);
    final color = _color(score, accentColor);
    final label = _label(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 4 segment bar ──────────────────────────────────────────────
        Row(
          children: List.generate(4, (i) {
            final filled = i < score;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: filled ? color : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 5),

        // ── Label ──────────────────────────────────────────────────────
        if (label.isNotEmpty)
          Text(
            'Password strength: $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
      ],
    );
  }
}
