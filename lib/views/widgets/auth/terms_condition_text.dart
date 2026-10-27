import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

/// "By tapping 'Sign Up' you accept our terms and condition"
/// with tappable green [terms] and [condition] links.
class TermsConditionText extends StatelessWidget {
  final VoidCallback? onTerms;
  final VoidCallback? onCondition;

  const TermsConditionText({
    super.key,
    this.onTerms,
    this.onCondition,
  });

  @override
  Widget build(BuildContext context) {
    // Base style — Poppins explicit because RichText bypasses the theme
    final base = GoogleFonts.poppins(
      fontSize: 13,
      color: const Color(0xFF8A8A9A),
      height: 1.6,
    );
    final link = GoogleFonts.poppins(
      fontSize: 13,
      color: AppTheme.primary,
      fontWeight: FontWeight.w600,
      height: 1.6,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'By tapping "Sign Up" you accept our '),
          TextSpan(
            text: 'terms',
            style: link,
            recognizer: TapGestureRecognizer()..onTap = onTerms,
          ),
          const TextSpan(text: '\nand '),
          TextSpan(
            text: 'condition',
            style: link,
            recognizer: TapGestureRecognizer()..onTap = onCondition,
          ),
        ],
      ),
    );
  }
}
