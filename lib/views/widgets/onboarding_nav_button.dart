import 'package:flutter/material.dart';

/// Circular navigation button used for back / next actions.
class OnboardingNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary; // green filled vs white outlined

  const OnboardingNavButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary ? const Color(0xFF2ECC71) : Colors.white,
          border: isPrimary
              ? null
              : Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF2ECC71).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFF555555),
          size: 22,
        ),
      ),
    );
  }
}
