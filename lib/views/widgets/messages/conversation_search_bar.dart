import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Rounded search field for filtering conversations.
class ConversationSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ConversationSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1A1A2E),
        ),
        decoration: const InputDecoration(
          hintText: 'Search message..',
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppTheme.textGrey,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppTheme.textGrey,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
