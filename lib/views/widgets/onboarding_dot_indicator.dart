import 'package:flutter/material.dart';

/// Page-dot indicator row.
class OnboardingDotIndicator extends StatelessWidget {
  final int totalDots;
  final int activeIndex;

  const OnboardingDotIndicator({
    super.key,
    required this.totalDots,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalDots, (i) => _Dot(isActive: i == activeIndex)),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;
  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 5,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF2ECC71)
            : const Color(0xFFD0D0D0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
