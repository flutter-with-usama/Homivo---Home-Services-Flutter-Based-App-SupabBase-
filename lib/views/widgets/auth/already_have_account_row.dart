import 'package:flutter/material.dart';
import 'app_outline_button.dart';

/// "Already have an account?" label + LOG IN outline button below it.
class AlreadyHaveAccountRow extends StatelessWidget {
  final VoidCallback? onLogin;

  const AlreadyHaveAccountRow({super.key, this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Label ──────────────────────────────────────────────────────────
        const Text(
          'Already have an account?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),

        const SizedBox(height: 12),

        // ── Reused outline button ──────────────────────────────────────────
        AppOutlineButton(
          label: 'LOG IN',
          onTap: onLogin,
        ),
      ],
    );
  }
}
