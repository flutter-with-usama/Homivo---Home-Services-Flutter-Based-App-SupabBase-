import 'package:flutter/material.dart';

/// "Or sign in with" divider + Google button only.
class SocialSignInRow extends StatelessWidget {
  final VoidCallback? onGoogle;

  const SocialSignInRow({
    super.key,
    this.onGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Divider label ──────────────────────────────────────────────────
        const Text(
          'Or sign in with',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF8A8A9A),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        // ── Google button (centred, fixed width) ───────────────────────────
        _SocialButton(
          onTap: onGoogle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GoogleLogo(),
              const SizedBox(width: 10),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Generic social button shell ───────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _SocialButton({required this.onTap, required this.child});

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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ── Google "G" logo ───────────────────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.network(
        'https://developers.google.com/identity/images/g-logo.png',
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(
          Icons.g_mobiledata_rounded,
          size: 24,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
