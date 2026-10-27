import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/booking_record_model.dart';
import '../../data/models/provider_dashboard_model.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../core/services/supabase_service.dart';

/// State for the Provider Home screen.
/// Completely decoupled from UI — only exposes data and actions.
class ProviderHomeProvider extends ChangeNotifier {
  final _bookingRepository = BookingRepository();
  final _notificationRepository = NotificationRepository();
  final _profileRepository = ProfileRepository();
  StreamSubscription<List<BookingRecordModel>>? _bookingSubscription;
  StreamSubscription<List<NotificationModel>>? _notificationSubscription;
  StreamSubscription? _authSubscription;

  ProviderHomeProvider() {
    _authSubscription = SupabaseService.authStateChanges.listen((_) {
      refresh();
    });
    refresh();
  }

  void refresh() {
    _loadProfile();
    _watchBookings();
    _watchNotifications();
  }

  void _watchBookings() {
    _bookingSubscription?.cancel();
    if (SupabaseService.currentUser == null) {
      _pendingJobs.clear();
      _activeJob = null;
      _jobsCompleted = 0;
      _earningsToday = 0;
      notifyListeners();
      return;
    }

    _bookingSubscription = _bookingRepository
        .watchCurrentProviderBookings()
        .listen((bookings) {
          final jobs = bookings.map(_toJob).toList();
          _pendingJobs
            ..clear()
            ..addAll(jobs.where((job) => job.status == JobStatus.pending));
          _activeJob = jobs.cast<JobModel?>().firstWhere(
            (job) => job?.status == JobStatus.accepted,
            orElse: () => null,
          );
          _jobsCompleted = jobs
              .where(
                (job) =>
                    job.status == JobStatus.completed &&
                    _isToday(job.completedAt),
              )
              .length;
          _earningsToday = jobs
              .where(
                (job) =>
                    job.status == JobStatus.completed &&
                    _isToday(job.completedAt),
              )
              .fold(0, (sum, job) => sum + job.amount);
          notifyListeners();
        }, onError: (_) {});
  }

  void _watchNotifications() {
    _notificationSubscription?.cancel();
    if (SupabaseService.currentUser == null) {
      _notificationCount = 0;
      notifyListeners();
      return;
    }

    _notificationSubscription = _notificationRepository
        .watchCurrentUserNotifications()
        .listen((notifications) {
          _notificationCount = notifications
              .where((notification) => !notification.isRead)
              .length;
          notifyListeners();
        }, onError: (_) {});
  }

  // ── Provider identity ──────────────────────────────────────────────────────
  String providerName = '';
  String providerSpecialty = '';

  // ── Online / Offline toggle ────────────────────────────────────────────────
  // ── Today's metrics ────────────────────────────────────────────────────────
  double _earningsToday = 0;
  int _jobsCompleted = 0;

  double get earningsToday => _earningsToday;
  int get jobsCompleted => _jobsCompleted;

  // ── Announcement banner ────────────────────────────────────────────────────
  // ── Active job ─────────────────────────────────────────────────────────────
  JobModel? _activeJob;

  JobModel? get activeJob => _activeJob;

  // ── Pending requests ───────────────────────────────────────────────────────
  final List<JobModel> _pendingJobs = [];

  List<JobModel> get pendingJobs => List.unmodifiable(_pendingJobs);

  int _notificationCount = 0;

  int get notificationCount => _notificationCount;

  // ── Actions ────────────────────────────────────────────────────────────────
  Future<void> acceptJob(String jobId, double amount) =>
      _bookingRepository.updateStatus(jobId, 'accepted', amount: amount);

  Future<void> rejectJob(String jobId) =>
      _bookingRepository.updateStatus(jobId, 'rejected');

  Future<void> completeActiveJob() async {
    if (_activeJob == null) return;
    await _bookingRepository.updateStatus(_activeJob!.id, 'completed');
  }

  Future<void> _loadProfile() async {
    final cachedProfile = _profileRepository.getCachedProfile();
    if (cachedProfile != null) {
      _applyProfile(cachedProfile.fullName, cachedProfile.specialty);
    }

    try {
      final profile = await _profileRepository.getCurrentProfile();
      _applyProfile(profile.fullName, profile.specialty);
    } catch (_) {}
  }

  void _applyProfile(String fullName, String specialty) {
    providerName = fullName;
    providerSpecialty = specialty;
    notifyListeners();
  }

  JobModel _toJob(BookingRecordModel booking) {
    return JobModel(
      id: booking.id,
      clientId: booking.clientId,
      clientName: booking.clientName,
      clientAvatar: _initials(booking.clientName),
      serviceType: booking.serviceName,
      serviceIcon: Icons.home_repair_service_rounded,
      serviceColor: const Color(0xFF00C566),
      address: booking.clientAddress,
      scheduledDate: booking.bookingDate,
      scheduledTime: booking.bookingTime,
      amount: booking.amount,
      completedAt: booking.completedAt,
      status: switch (booking.status) {
        'accepted' => JobStatus.accepted,
        'rejected' => JobStatus.rejected,
        'completed' => JobStatus.completed,
        _ => JobStatus.pending,
      },
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'C';
  }

  bool _isToday(DateTime? value) {
    if (value == null) return false;
    final local = value.toLocal();
    final today = DateTime.now();
    return local.year == today.year &&
        local.month == today.month &&
        local.day == today.day;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _bookingSubscription?.cancel();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
