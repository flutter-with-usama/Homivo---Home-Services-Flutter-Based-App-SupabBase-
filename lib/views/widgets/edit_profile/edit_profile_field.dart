import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Reusable labelled input field for the edit profile screen.
/// Shows a section label above and a rounded text field below.
class EditProfileField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final IconData prefixIcon;
  final Color iconColor;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool readOnly;       // e.g. email is read-only after registration
  final String? helperText;  // shown below field when readOnly

  const EditProfileField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.prefixIcon,
    this.iconColor = AppTheme.primary,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──────────────────────────────────────────────────────
        Row(
          children: [
            Icon(prefixIcon, size: 15, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: readOnly ? AppTheme.textGrey : const Color(0xFF1A1A2E),
              ),
            ),
            if (readOnly) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Cannot be changed',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        // ── Input ───────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: readOnly
                ? const Color(0xFFF6F8FA)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: readOnly
                  ? const Color(0xFFE8E8E8)
                  : AppTheme.primary.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: readOnly
                ? []
                : [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: TextField(
            controller:      controller,
            onChanged:       onChanged,
            readOnly:        readOnly,
            keyboardType:    keyboardType,
            textInputAction: textInputAction,
            style: TextStyle(
              fontSize: 14,
              color: readOnly
                  ? AppTheme.textGrey
                  : const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w400,
              ),
              border:          InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // ── Helper text ─────────────────────────────────────────────────
        if (helperText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              helperText!,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textGrey,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
