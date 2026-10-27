import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Reusable info row — green circle icon + label above + bold value below.
/// Used for budget, location, experience etc.
class ProviderInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProviderInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Green circle icon
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppTheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),

        const SizedBox(width: 16),

        // Label + value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
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
