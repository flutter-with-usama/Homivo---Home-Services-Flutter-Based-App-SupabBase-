import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_service.dart';
import '../../core/services/local_cache_service.dart';
import '../models/app_profile_model.dart';
import '../models/register_model.dart';

class ProfileRepository {
  final SupabaseClient _db = SupabaseService.client;
  final LocalCacheService _cache = LocalCacheService.instance;

  AppProfileModel? getCachedProfile() =>
      _cache.getProfile(userId: SupabaseService.currentUser?.id);

  Future<AppProfileModel> getCurrentProfile() async {
    final user = _requireUser();
    final cachedProfile = _cache.getProfile(userId: user.id);

    try {
      final row = await _db
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (row != null) {
        final profile = AppProfileModel.fromMap(row);
        await _cache.saveProfile(profile);
        return profile;
      }

      final metadata = user.userMetadata ?? const <String, dynamic>{};
      final profile = AppProfileModel(
        id: user.id,
        fullName: metadata['full_name'] as String? ?? '',
        email: user.email ?? metadata['email'] as String? ?? '',
        phone: metadata['phone'] as String? ?? '',
        address: metadata['address'] as String? ?? '',
        role: switch (metadata['role']) {
          'provider' => UserRole.provider,
          'admin' => UserRole.admin,
          _ => UserRole.client,
        },
        specialty: metadata['specialty'] as String? ?? '',
      );
      await _db.from('profiles').upsert(profile.toMap());
      await _cache.saveProfile(profile);
      return profile;
    } catch (_) {
      if (cachedProfile != null) return cachedProfile;
      rethrow;
    }
  }

  Future<void> updateCurrentProfile({
    required String fullName,
    required String phone,
    required String address,
    required UserRole role,
    String specialty = '',
  }) async {
    final user = _requireUser();
    final profile = AppProfileModel(
      id: user.id,
      fullName: fullName.trim(),
      email: user.email ?? '',
      phone: phone.trim(),
      address: address.trim(),
      role: role,
      specialty: specialty.trim(),
    );

    await _db.from('profiles').upsert(profile.toMap());
    await _cache.saveProfile(profile);
    await _db.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': profile.fullName,
          'phone': profile.phone,
          'address': profile.address,
          'role': profile.role.name,
          'specialty': profile.specialty,
        },
      ),
    );
  }

  Future<void> signOut() => _db.auth.signOut();

  User _requireUser() {
    final user = _db.auth.currentUser;
    if (user == null) {
      throw const AuthException('Please log in again.');
    }
    return user;
  }
}
