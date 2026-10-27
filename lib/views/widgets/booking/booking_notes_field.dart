import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Multi-line notes text area for additional requirements.
class BookingNotesField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final Color accentColor;

  const BookingNotesField({
    super.key,
    required this.onChanged,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
      ),
      child: TextField(
        onChanged: onChanged,
        maxLines: 4,
        minLines: 4,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1A1A2E),
          height: 1.5,
        ),
        decoration: const InputDecoration(
          hintText: 'Describe your problem or any special requirements...',
          hintStyle: TextStyle(
            fontSize: 13,
            color: AppTheme.textGrey,
            height: 1.5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
