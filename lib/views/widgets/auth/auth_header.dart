import 'package:flutter/material.dart';

/// Section heading used at the top of auth forms.
/// Shows a bold [title] and a lighter [subtitle] below it.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF8A8A9A),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
