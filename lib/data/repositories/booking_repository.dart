import '../../core/services/supabase_service.dart';
import '../models/booking_record_model.dart';

class BookingRepository {
  Stream<List<BookingRecordModel>> watchCurrentClientBookings() {
    final user = SupabaseService.currentUser;
    if (user == null) {
      return Stream.error(StateError('Please log in again.'));
    }

    return SupabaseService.client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('client_id', user.id)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(BookingRecordModel.fromMap).toList());
  }

  Stream<List<BookingRecordModel>> watchCurrentProviderBookings() {
    final user = SupabaseService.currentUser;
    if (user == null) {
      return Stream.error(StateError('Please log in again.'));
    }

    return SupabaseService.client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('provider_id', user.id)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(BookingRecordModel.fromMap).toList());
  }

  Future<void> updateStatus(
    String bookingId,
    String status, {
    double? amount,
  }) async {
    if (status == 'accepted') {
      if (amount == null || amount <= 0) {
        throw ArgumentError.value(amount, 'amount', 'Enter a valid quote.');
      }
    }

    await SupabaseService.client.rpc(
      'update_provider_booking',
      params: {
        'booking_id': bookingId,
        'new_status': status,
        'quoted_amount': amount,
      },
    );
  }
}
