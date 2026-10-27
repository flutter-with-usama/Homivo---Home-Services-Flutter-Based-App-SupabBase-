class BookingRecordModel {
  final String id;
  final String clientId;
  final String providerName;
  final String clientName;
  final String clientAddress;
  final String serviceName;
  final String bookingDate;
  final String bookingTime;
  final String notes;
  final String status;
  final double amount;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  const BookingRecordModel({
    required this.id,
    required this.clientId,
    required this.providerName,
    required this.clientName,
    required this.clientAddress,
    required this.serviceName,
    required this.bookingDate,
    required this.bookingTime,
    required this.notes,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.acceptedAt,
    required this.completedAt,
  });

  factory BookingRecordModel.fromMap(Map<String, dynamic> map) {
    return BookingRecordModel(
      id: map['id'] as String? ?? '',
      clientId: map['client_id'] as String? ?? '',
      providerName: map['provider_name'] as String? ?? '',
      clientName: map['client_name'] as String? ?? '',
      clientAddress: map['client_address'] as String? ?? '',
      serviceName: map['service_name'] as String? ?? '',
      bookingDate: map['booking_date'] as String? ?? '',
      bookingTime: map['booking_time'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      createdAt:
          DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      acceptedAt: DateTime.tryParse(map['accepted_at'] as String? ?? ''),
      completedAt: DateTime.tryParse(map['completed_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'client_id': clientId,
    'provider_name': providerName,
    'client_name': clientName,
    'client_address': clientAddress,
    'service_name': serviceName,
    'booking_date': bookingDate,
    'booking_time': bookingTime,
    'notes': notes,
    'status': status,
    'amount': amount,
    'created_at': createdAt.toIso8601String(),
    'accepted_at': acceptedAt?.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };
}
