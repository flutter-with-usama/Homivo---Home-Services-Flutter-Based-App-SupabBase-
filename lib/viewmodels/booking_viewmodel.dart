import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/booking_model.dart';
import '../data/models/provider_profile_model.dart';
import '../data/repositories/notification_repository.dart';

class BookingViewModel extends ChangeNotifier {
  final ProviderProfileModel provider;
  final _notificationRepository = NotificationRepository();
  BookingModel _state = const BookingModel();
  String? _errorMessage;

  BookingViewModel({required this.provider});

  // ── Available time slots ───────────────────────────────────────────────────
  List<String> get timeSlots {
    final now = DateTime.now();
    final firstSlot = now.minute == 0 && now.second == 0 && now.millisecond == 0
        ? DateTime(now.year, now.month, now.day, now.hour)
        : DateTime(now.year, now.month, now.day, now.hour + 1);

    return List.generate(
      24,
      (index) => _formatTime(firstSlot.add(Duration(hours: index))),
    );
  }

  // ── Exposed state ──────────────────────────────────────────────────────────
  DateTime? get selectedDate => _state.selectedDate;
  String? get selectedTime => _state.selectedTime;
  String get notes => _state.notes;
  double? get clientBudget => _state.clientBudget;
  bool get isLoading => _state.isLoading;
  bool get canConfirm => _state.canConfirm;
  String? get errorMessage => _errorMessage;

  // ── Actions ────────────────────────────────────────────────────────────────
  void selectDate(DateTime date) {
    _state = _state.copyWith(selectedDate: date);
    notifyListeners();
  }

  void selectTime(String time) {
    _state = _state.copyWith(selectedTime: time);
    notifyListeners();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:00 $period';
  }

  void onNotesChanged(String value) {
    _state = _state.copyWith(notes: value);
    notifyListeners();
  }

  void onBudgetChanged(String value) {
    final parsed = double.tryParse(value.trim());
    _state = _state.copyWith(clientBudget: parsed, clearBudget: parsed == null);
    notifyListeners();
  }

  Future<bool> confirm() async {
    if (!canConfirm) return false;
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    _errorMessage = null;

    try {
      await _notificationRepository.createBookingRequest(
        providerId: provider.id,
        service: provider.serviceTitle,
        date: formattedDate,
        time: selectedTime ?? '',
        notes: notes,
        clientBudget: _state.clientBudget,
      );
      return true;
    } catch (error) {
      _errorMessage = _bookingErrorMessage(error);
      return false;
    } finally {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  String _bookingErrorMessage(Object error) {
    if (error is PostgrestException) {
      final message = error.message.toLowerCase();

      if (message.contains('notify_provider_of_booking') ||
          message.contains('schema cache') ||
          message.contains('permission denied')) {
        return 'Booking setup is incomplete. Run notification_setup.sql in '
            'Supabase SQL Editor, then restart the app. Details: '
            '${error.message}';
      }
      if (message.contains('client profile not found')) {
        return 'Your client profile is missing. Log out, log in again, and '
            'complete your profile before booking.';
      }
      if (message.contains('provider not found')) {
        return 'This service provider is no longer available. Choose another '
            'provider.';
      }
      if (message.contains('only clients can create booking requests')) {
        return 'Only client accounts can create booking requests.';
      }

      return 'Could not send your booking: ${error.message}';
    }

    return 'Could not send your booking. Check your connection and try again.';
  }

  /// Formatted date string for display.
  String get formattedDate {
    if (_state.selectedDate == null) return '';
    final d = _state.selectedDate!;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}
