import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/notification_model.dart';
import '../data/repositories/notification_repository.dart';

class NotificationsViewModel extends ChangeNotifier {
  final _repository = NotificationRepository();
  StreamSubscription<List<NotificationModel>>? _subscription;

  List<NotificationModel> _items = const [];
  bool _isLoading = true;
  String? _errorMessage;

  NotificationsViewModel() {
    _subscription = _repository.watchCurrentUserNotifications().listen(
      (items) {
        _items = items;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        _errorMessage = 'Could not load notifications. Please try again.';
        notifyListeners();
      },
    );
  }

  List<NotificationModel> get all => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _items.where((n) => !n.isRead).length;

  Map<String, List<NotificationModel>> get grouped {
    final now = DateTime.now();
    final today = <NotificationModel>[];
    final yesterday = <NotificationModel>[];
    final earlier = <NotificationModel>[];

    for (final notification in _items) {
      final created = notification.dateTime;
      final dayDifference = DateTime(
        now.year,
        now.month,
        now.day,
      ).difference(DateTime(created.year, created.month, created.day)).inDays;
      if (dayDifference == 0) {
        today.add(notification);
      } else if (dayDifference == 1) {
        yesterday.add(notification);
      } else {
        earlier.add(notification);
      }
    }

    return {
      if (today.isNotEmpty) 'Today': today,
      if (yesterday.isNotEmpty) 'Yesterday': yesterday,
      if (earlier.isNotEmpty) 'Earlier': earlier,
    };
  }

  Future<void> markRead(String id) => _repository.markRead(id);

  Future<void> markAllRead() => _repository.markAllRead();

  Future<void> remove(String id) => _repository.remove(id);

  Future<void> clearAll() => _repository.clearAll();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
