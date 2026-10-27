import 'package:flutter/material.dart';

/// 3-column grid of time slot chips — tap to select one.
class BookingTimeSlots extends StatelessWidget {
  final List<String> slots;
  final String? selectedSlot;
  final Color accentColor;
  final ValueChanged<String> onSlotSelected;

  const BookingTimeSlots({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.accentColor,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Build rows of 3
    final rows = <Widget>[];
    for (int i = 0; i < slots.length; i += 3) {
      rows.add(
        Row(
          children: List.generate(3, (j) {
            final idx = i + j;
            if (idx >= slots.length) return const Expanded(child: SizedBox());
            final slot = slots[idx];
            final isSelected = slot == selectedSlot;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: j < 2 ? 10 : 0,
                ),
                child: GestureDetector(
                  onTap: () => onSlotSelected(slot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor : const Color(0xFFF6F8FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? accentColor
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
      if (i + 3 < slots.length) rows.add(const SizedBox(height: 10));
    }

    return Column(children: rows);
  }
}
