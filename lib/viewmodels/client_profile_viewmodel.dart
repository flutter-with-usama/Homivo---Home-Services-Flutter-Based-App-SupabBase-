import 'dart:async';

import 'package:flutter/foundation.dart';
import '../data/models/app_profile_model.dart';
import '../data/models/booking_record_model.dart';
import '../data/models/client_profile_model.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/profile_repository.dart';

class ClientProfileViewModel extends ChangeNotifier {
  final _repository = ProfileRepository();
  final _bookingRepository = BookingRepository();
  StreamSubscription<List<BookingRecordModel>>? _bookingSubscription;

  ClientProfileModel _profile = const ClientProfileModel(
    fullName: '',
    email: '',
    phone: '',
    address: '',
    initials: '',
    totalBookings: 0,
    completedBookings: 0,
  );

  ClientProfileViewModel() {
    loadProfile();
    _bookingSubscription = _bookingRepository
        .watchCurrentClientBookings()
        .listen((bookings) {
          _profile = _profile.copyWith(
            totalBookings: bookings.length,
            completedBookings: bookings
                .where((booking) => booking.status == 'completed')
                .length,
          );
          notifyListeners();
        }, onError: (_) {});
  }

  ClientProfileModel get profile => _profile;

  // ── Expose individual fields for narrow selectors ──────────────────────────
  String get fullName => _profile.fullName;
  String get email => _profile.email;
  String get phone => _profile.phone;
  String get address => _profile.address;
  String get initials => _profile.initials;
  int get totalBookings => _profile.totalBookings;
  int get completedBookings => _profile.completedBookings;

  Future<void> loadProfile() async {
    final cachedProfile = _repository.getCachedProfile();
    if (cachedProfile != null) {
      _applyProfile(cachedProfile);
    }

    try {
      final profile = await _repository.getCurrentProfile();
      _applyProfile(profile);
    } catch (_) {
      // Keep the current UI state if the profile cannot be loaded.
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  /// Update profile fields (called from Edit Profile screen).
  void updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) {
    _profile = _profile.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      address: address,
      initials: fullName == null ? null : _initials(fullName),
    );
    notifyListeners();
  }

  /// Sign out — clears local state; caller handles navigation.
  Future<void> logout() async {
    await _repository.signOut();
  }

  void _applyProfile(AppProfileModel profile) {
    _profile = _profile.copyWith(
      fullName: profile.fullName,
      email: profile.email,
      phone: profile.phone,
      address: profile.address,
      initials: _initials(profile.fullName),
    );
    notifyListeners();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  void dispose() {
    _bookingSubscription?.cancel();
    super.dispose();
  }
}
