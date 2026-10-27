import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Sticky bottom bar — price summary on the left + Confirm button on the right.
class BookingConfirmBar extends StatelessWidget {
  final String priceRange;
  final String? selectedDate;
  final String? selectedTime;
  final bool isLoading;
  final bool canConfirm;
  final VoidCallback onConfirm;

  const BookingConfirmBar({
    super.key,
    required this.priceRange,
    required this.selectedDate,
    required this.selectedTime,
    required this.isLoading,
    required this.canConfirm,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Summary row ──────────────────────────────────────────────
            if (selectedDate != null || selectedTime != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    if (selectedDate != null) ...[
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppTheme.textGrey),
                      const SizedBox(width: 4),
                      Text(
                        selectedDate!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                    if (selectedDate != null && selectedTime != null)
                      const Text('  ·  ',
                          style: TextStyle(
                              color: AppTheme.textGrey, fontSize: 12)),
                    if (selectedTime != null) ...[
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: AppTheme.textGrey),
                      const SizedBox(width: 4),
                      Text(
                        selectedTime!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // ── Price + Confirm button ────────────────────────────────────
            Row(
              children: [
                // Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Cost',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        priceRange,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Confirm button
                GestureDetector(
                  onTap: canConfirm && !isLoading ? onConfirm : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      gradient: canConfirm
                          ? const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.primaryDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: canConfirm ? null : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: canConfirm
                          ? [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: canConfirm
                                    ? Colors.white
                                    : AppTheme.textGrey,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
