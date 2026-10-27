import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Date picker field — tapping opens the system date picker.
class BookingDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String formattedDate;
  final Color accentColor;
  final ValueChanged<DateTime> onDateSelected;

  const BookingDatePicker({
    super.key,
    required this.selectedDate,
    required this.formattedDate,
    required this.accentColor,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: accentColor,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;

    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasDate
                ? accentColor.withValues(alpha: 0.50)
                : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasDate ? formattedDate : 'mm/dd/yyyy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      hasDate ? FontWeight.w600 : FontWeight.w400,
                  color: hasDate
                      ? const Color(0xFF1A1A2E)
                      : AppTheme.textGrey,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: hasDate ? accentColor : AppTheme.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}
