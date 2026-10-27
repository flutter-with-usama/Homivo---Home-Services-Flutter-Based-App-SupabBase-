import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/app_profile_model.dart';
import '../../data/models/booking_record_model.dart';

class LocalCacheService {
  LocalCacheService._();

  static final instance = LocalCacheService._();

  static const _lastProfileIdKey = 'profile.last_id';
  static const _onboardingCompletedKey = 'onboarding.completed';

  late final SharedPreferences _preferences;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  bool get onboardingCompleted =>
      _preferences.getBool(_onboardingCompletedKey) ?? false;

  Future<void> markOnboardingCompleted() =>
      _preferences.setBool(_onboardingCompletedKey, true);

  AppProfileModel? getProfile({String? userId}) {
    final profileId = userId ?? _preferences.getString(_lastProfileIdKey);
    if (profileId == null || profileId.isEmpty) return null;

    final profileJson = _preferences.getString(_profileKey(profileId));
    if (profileJson == null) return null;

    try {
      return AppProfileModel.fromMap(
        jsonDecode(profileJson) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(AppProfileModel profile) async {
    await _preferences.setString(
      _profileKey(profile.id),
      jsonEncode(profile.toMap()),
    );
    await _preferences.setString(_lastProfileIdKey, profile.id);
  }

  List<BookingRecordModel> getBookings({
    required String userId,
    required String scope,
  }) {
    final bookingsJson = _preferences.getString(_bookingsKey(userId, scope));
    if (bookingsJson == null) return const [];

    try {
      final rows = jsonDecode(bookingsJson) as List<dynamic>;
      return rows
          .whereType<Map<String, dynamic>>()
          .map(BookingRecordModel.fromMap)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> saveBookings({
    required String userId,
    required String scope,
    required List<BookingRecordModel> bookings,
  }) async {
    await _preferences.setString(
      _bookingsKey(userId, scope),
      jsonEncode(bookings.map((booking) => booking.toMap()).toList()),
    );
  }

  String _profileKey(String userId) => 'profile.$userId';

  String _bookingsKey(String userId, String scope) =>
      'bookings.$scope.$userId';
}
