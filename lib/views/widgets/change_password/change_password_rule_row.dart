import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// A single password rule row — shows a tick or cross next to the rule text.
/// Used to give the user live feedback as they type their new password.
class ChangePasswordRuleRow extends StatelessWidget {
  final String label;
  final bool passed;
  final Color accentColor;

  const ChangePasswordRuleRow({
    super.key,
    required this.label,
    required this.passed,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: passed
                  ? accentColor.withValues(alpha: 0.12)
                  : const Color(0xFFF3F4F6),
            ),
            child: Icon(
              passed ? Icons.check_rounded : Icons.close_rounded,
              size: 11,
              color: passed ? accentColor : AppTheme.textGrey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: passed ? const Color(0xFF1A1A2E) : AppTheme.textGrey,
              fontWeight:
                  passed ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
