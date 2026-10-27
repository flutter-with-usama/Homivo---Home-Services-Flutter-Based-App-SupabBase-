import 'dart:async';

import 'package:flutter/material.dart';
import '../data/models/app_profile_model.dart';
import '../data/models/booking_record_model.dart';
import '../data/models/provider_dashboard_model.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../core/services/supabase_service.dart';

/// Manages the service provider dashboard state.
class ProviderDashboardViewModel extends ChangeNotifier {
  final _profileRepository = ProfileRepository();
  final _bookingRepository = BookingRepository();
  StreamSubscription<List<BookingRecordModel>>? _bookingSubscription;
  StreamSubscription? _authSubscription;

  ProviderDashboardViewModel() {
    _authSubscription = SupabaseService.authStateChanges.listen((_) {
      loadProfile();
    });
  }

  void _watchBookings() {
    _bookingSubscription?.cancel();
    if (SupabaseService.currentUser == null) {
      _jobs.clear();
      notifyListeners();
      return;
    }

    _bookingSubscription = _bookingRepository
        .watchCurrentProviderBookings()
        .listen((bookings) {
          _jobs
            ..clear()
            ..addAll(bookings.map(_toJob));
          notifyListeners();
        }, onError: (_) {});
  }

  // ── Provider info (mutable — updated via Edit Profile) ────────────────────
  String _providerName = '';
  String _providerSpecialty = '';
  String _providerPhone = '';
  String _providerEmail = '';
  String _providerArea = '';

  String get providerName => _providerName;
  String get providerSpecialty => _providerSpecialty;
  String get providerPhone => _providerPhone;
  String get providerEmail => _providerEmail;
  String get providerArea => _providerArea;

  Future<void> loadProfile() async {
    _watchBookings();
    final cachedProfile = _profileRepository.getCachedProfile();
    if (cachedProfile != null) {
      _applyProfile(cachedProfile);
    }

    try {
      final profile = await _profileRepository.getCurrentProfile();
      _applyProfile(profile);
    } catch (_) {
      // Keep the current UI state if the profile cannot be loaded.
    }
  }

  Future<void> logout() => _profileRepository.signOut();

  void _applyProfile(AppProfileModel profile) {
    _providerName = profile.fullName;
    _providerEmail = profile.email;
    _providerPhone = profile.phone;
    _providerArea = profile.address;
    _providerSpecialty = profile.specialty;
    notifyListeners();
  }

  String get providerInitials {
    final parts = _providerName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return _providerName.isNotEmpty ? _providerName[0].toUpperCase() : 'P';
  }

  /// Called after a successful Edit Profile save.
  void updateProfile({
    required String fullName,
    required String phone,
    required String serviceArea,
    required String specialty,
  }) {
    _providerName = fullName;
    _providerPhone = phone;
    _providerArea = serviceArea;
    _providerSpecialty = specialty;
    notifyListeners();
  }

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  void onNavTap(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  // ── Earnings ───────────────────────────────────────────────────────────────
  EarningsSummaryModel get earnings => EarningsSummaryModel(
    totalEarnings: _jobs
        .where((j) => j.status == JobStatus.completed)
        .fold(0, (sum, j) => sum + j.amount),
    thisWeek: _jobs
        .where(
          (j) => j.status == JobStatus.completed && _isThisWeek(j.completedAt),
        )
        .fold(0, (sum, j) => sum + j.amount),
    thisMonth: _jobs
        .where(
          (j) => j.status == JobStatus.completed && _isThisMonth(j.completedAt),
        )
        .fold(0, (sum, j) => sum + j.amount),
    completedJobs: _jobs.where((j) => j.status == JobStatus.completed).length,
    activeJobs: _jobs.where((j) => j.status == JobStatus.accepted).length,
    pendingJobs: _jobs.where((j) => j.status == JobStatus.pending).length,
  );

  // ── Jobs ───────────────────────────────────────────────────────────────────
  final List<JobModel> _jobs = [];

  List<JobModel> get allJobs => List.unmodifiable(_jobs);

  List<JobModel> get pendingJobs =>
      _jobs.where((j) => j.status == JobStatus.pending).toList();

  List<JobModel> get activeJobs =>
      _jobs.where((j) => j.status == JobStatus.accepted).toList();

  List<JobModel> get completedJobs =>
      _jobs.where((j) => j.status == JobStatus.completed).toList();

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> acceptJob(String jobId, double amount) =>
      _bookingRepository.updateStatus(jobId, 'accepted', amount: amount);

  Future<void> rejectJob(String jobId) =>
      _bookingRepository.updateStatus(jobId, 'rejected');

  Future<void> completeJob(String jobId) =>
      _bookingRepository.updateStatus(jobId, 'completed');

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

  bool _isThisWeek(DateTime? value) {
    if (value == null) return false;
    final local = value.toLocal();
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: today.weekday - 1));
    return !local.isBefore(start);
  }

  bool _isThisMonth(DateTime? value) {
    if (value == null) return false;
    final local = value.toLocal();
    final today = DateTime.now();
    return local.year == today.year && local.month == today.month;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _bookingSubscription?.cancel();
    super.dispose();
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
