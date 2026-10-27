/// Holds the booking form state as a pure data class.
class BookingModel {
  final DateTime? selectedDate;
  final String? selectedTime;
  final String notes;
  final double? clientBudget;
  final bool isLoading;

  const BookingModel({
    this.selectedDate,
    this.selectedTime,
    this.notes = '',
    this.clientBudget,
    this.isLoading = false,
  });

  bool get canConfirm => selectedDate != null && selectedTime != null;

  BookingModel copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    String? notes,
    double? clientBudget,
    bool? isLoading,
    bool clearDate = false,
    bool clearTime = false,
    bool clearBudget = false,
  }) => BookingModel(
    selectedDate: clearDate ? null : selectedDate ?? this.selectedDate,
    selectedTime: clearTime ? null : selectedTime ?? this.selectedTime,
    notes: notes ?? this.notes,
    clientBudget: clearBudget ? null : clientBudget ?? this.clientBudget,
    isLoading: isLoading ?? this.isLoading,
  );
}
