import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/provider_profile_model.dart';
import '../../viewmodels/booking_viewmodel.dart';

// ── Components ─────────────────────────────────────────────────────────────────
import '../widgets/booking/booking_provider_card.dart';
import '../widgets/booking/booking_section_header.dart';
import '../widgets/booking/booking_date_picker.dart';
import '../widgets/booking/booking_time_slots.dart';
import '../widgets/booking/booking_notes_field.dart';
import '../widgets/booking/booking_confirm_bar.dart';

/// Full booking screen — assembles all booking components.
class BookingScreen extends StatefulWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;

  const BookingScreen({
    super.key,
    required this.provider,
    required this.serviceColor,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final BookingViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = BookingViewModel(provider: widget.provider);
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final success = await _vm.confirm();
    if (!mounted) return;
    if (success) {
      _showSuccessSheet();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_vm.errorMessage ?? 'Could not send booking.')),
      );
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true, // lets the sheet grow to fit content
      builder: (_) => _SuccessSheet(
        provider: widget.provider,
        serviceColor: widget.serviceColor,
        date: _vm.formattedDate,
        time: _vm.selectedTime ?? '',
        onDone: () {
          Navigator.pop(context); // close sheet
          Navigator.pop(context); // back to detail
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    // Use service color for accents, fall back to app primary
    final accent = widget.serviceColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),

      // ── App bar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
        title: const Text(
          'Book Service',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),

      // ── Sticky bottom confirm bar ────────────────────────────────────────
      bottomNavigationBar: BookingConfirmBar(
        priceRange: widget.provider.priceRange,
        selectedDate: _vm.selectedDate != null ? _vm.formattedDate : null,
        selectedTime: _vm.selectedTime,
        isLoading: _vm.isLoading,
        canConfirm: _vm.canConfirm,
        onConfirm: _confirm,
      ),

      // ── Scrollable body ──────────────────────────────────────────────────
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Provider card ───────────────────────────────────────
              BookingProviderCard(
                provider: widget.provider,
                serviceColor: accent,
              ),

              const SizedBox(height: 20),

              // ── 2. Select Date ─────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSectionHeader(
                      icon: Icons.calendar_month_rounded,
                      title: 'Select Date',
                      color: accent,
                    ),
                    const SizedBox(height: 16),
                    BookingDatePicker(
                      selectedDate: _vm.selectedDate,
                      formattedDate: _vm.formattedDate,
                      accentColor: accent,
                      onDateSelected: _vm.selectDate,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── 3. Select Time ─────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSectionHeader(
                      icon: Icons.access_time_rounded,
                      title: 'Select Time',
                      color: accent,
                    ),
                    const SizedBox(height: 16),
                    BookingTimeSlots(
                      slots: _vm.timeSlots,
                      selectedSlot: _vm.selectedTime,
                      accentColor: accent,
                      onSlotSelected: _vm.selectTime,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── 4. Additional Notes ────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSectionHeader(
                      icon: Icons.description_outlined,
                      title: 'Additional Notes',
                      color: accent,
                    ),
                    const SizedBox(height: 16),
                    BookingNotesField(
                      onChanged: _vm.onNotesChanged,
                      accentColor: accent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── 5. Your Budget ─────────────────────────────────────────
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSectionHeader(
                      icon: Icons.attach_money_rounded,
                      title: 'Your Budget',
                      color: accent,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optional — lets the provider see what you have in mind.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _BudgetField(
                      accentColor: accent,
                      onChanged: _vm.onBudgetChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Budget input field ────────────────────────────────────────────────────────
class _BudgetField extends StatelessWidget {
  final Color accentColor;
  final ValueChanged<String> onChanged;

  const _BudgetField({required this.accentColor, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: '0.00',
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '\$',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFFF6F8FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
      ),
    );
  }
}

// ── Reusable white card wrapper ───────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Booking success bottom sheet ──────────────────────────────────────────────
class _SuccessSheet extends StatelessWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;
  final String date;
  final String time;
  final VoidCallback onDone;

  const _SuccessSheet({
    required this.provider,
    required this.serviceColor,
    required this.date,
    required this.time,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      // SafeArea handles bottom nav bar insets — no fixed bottom padding
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppTheme.primary,
                  size: 38,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your appointment with ${provider.name} has been booked.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textGrey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // Booking summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Provider',
                      value: provider.name,
                      color: serviceColor,
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: date,
                      color: serviceColor,
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      icon: Icons.access_time_rounded,
                      label: 'Time',
                      value: time,
                      color: serviceColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Done button
              GestureDetector(
                onTap: onDone,
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
