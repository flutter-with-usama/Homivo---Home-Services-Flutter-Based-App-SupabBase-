import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Full-width green outlined pill button (no fill).
class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppTheme.primary, width: 1.8),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
