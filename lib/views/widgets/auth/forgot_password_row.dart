import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../screens/forgot_password_screen.dart';

/// "Forgot your password? Reset here" — tapping navigates to ForgotPasswordScreen.
class ForgotPasswordRow extends StatelessWidget {
  /// Optional override — if null, navigates to [ForgotPasswordScreen].
  final VoidCallback? onReset;

  const ForgotPasswordRow({super.key, this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Forgot your password?  ',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textGrey,
          ),
        ),
        GestureDetector(
          onTap: onReset ??
              () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
          child: const Text(
            'Reset here',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
