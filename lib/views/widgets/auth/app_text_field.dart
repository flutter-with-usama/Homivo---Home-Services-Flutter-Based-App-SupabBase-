import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Reusable rounded text field for auth forms.
///
/// Supports:
/// - Hint text
/// - Password mode with eye-toggle via [obscureText] + [onToggleObscure]
/// - Custom keyboard type
/// - Error state (red border)
class AppTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;
  final String? errorText;
  final TextInputAction textInputAction;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    final borderColor =
        hasError ? const Color(0xFFEF4444) : AppTheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Input field ────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofocus: autofocus,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Color(0xFFB0B0C0),
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              // Eye toggle suffix for password fields
              suffixIcon: onToggleObscure != null
                  ? GestureDetector(
                      onTap: onToggleObscure,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.primary,
                          size: 22,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),

        // ── Error text ─────────────────────────────────────────────────────
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
