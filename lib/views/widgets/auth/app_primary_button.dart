import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Full-width green filled pill button.
/// Shows a [CircularProgressIndicator] when [isLoading] is true.
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [AppTheme.primary.withValues(alpha: 0.6),
                   AppTheme.primaryDark.withValues(alpha: 0.6)]
                : [AppTheme.primary, AppTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.40),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
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
