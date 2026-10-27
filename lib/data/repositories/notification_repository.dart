import 'dart:async';

import '../../core/services/supabase_service.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  Stream<List<NotificationModel>> watchCurrentUserNotifications() {
    final user = SupabaseService.currentUser;
    if (user == null) {
      return Stream.error(StateError('Please log in again.'));
    }

    return SupabaseService.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('recipient_id', user.id)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(NotificationModel.fromMap).toList());
  }

  Future<void> markRead(String id) async {
    await SupabaseService.client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }

  Future<void> markAllRead() async {
    final user = SupabaseService.currentUser;
    if (user == null) throw StateError('Please log in again.');

    await SupabaseService.client
        .from('notifications')
        .update({'is_read': true})
        .eq('recipient_id', user.id)
        .eq('is_read', false);
  }

  Future<void> remove(String id) async {
    await SupabaseService.client.from('notifications').delete().eq('id', id);
  }

  Future<void> clearAll() async {
    final user = SupabaseService.currentUser;
    if (user == null) throw StateError('Please log in again.');

    await SupabaseService.client
        .from('notifications')
        .delete()
        .eq('recipient_id', user.id);
  }

  Future<void> createBookingRequest({
    required String providerId,
    required String service,
    required String date,
    required String time,
    required String notes,
    double? clientBudget,
  }) async {
    await SupabaseService.client.rpc(
      'notify_provider_of_booking',
      params: {
        'provider_id': providerId,
        'service_name': service,
        'booking_date': date,
        'booking_time': time,
        'booking_notes': notes,
        'client_budget': clientBudget ?? 0,
      },
    );
  }
}
