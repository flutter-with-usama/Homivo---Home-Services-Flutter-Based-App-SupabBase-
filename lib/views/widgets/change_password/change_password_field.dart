import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Labelled password field with show/hide toggle.
/// Used in the Change Password screen.
class ChangePasswordField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final VoidCallback onToggleObscure;
  final Color accentColor;
  final TextInputAction textInputAction;
  final String? errorText;

  const ChangePasswordField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.obscureText,
    required this.onToggleObscure,
    required this.accentColor,
    this.textInputAction = TextInputAction.next,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──────────────────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.lock_outline_rounded, size: 14, color: accentColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: hasError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── Input ───────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? const Color(0xFFEF4444)
                  : accentColor.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (hasError
                        ? const Color(0xFFEF4444)
                        : accentColor)
                    .withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller:      controller,
            onChanged:       onChanged,
            obscureText:     obscureText,
            textInputAction: textInputAction,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              suffixIcon: GestureDetector(
                onTap: onToggleObscure,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: accentColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Error text ──────────────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
