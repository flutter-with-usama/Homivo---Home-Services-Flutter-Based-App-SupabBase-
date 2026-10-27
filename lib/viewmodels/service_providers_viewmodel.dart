import 'package:flutter/material.dart';

import '../data/models/app_profile_model.dart';
import '../data/models/provider_profile_model.dart';
import '../data/repositories/provider_directory_repository.dart';

class ServiceProvidersViewModel extends ChangeNotifier {
  final _repository = ProviderDirectoryRepository();

  List<ProviderProfileModel> _providers = const [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<ProviderProfileModel> getByService(String serviceKey) {
    final key = serviceKey.toLowerCase();
    return _providers.where((provider) => provider.serviceKey == key).toList();
  }

  Future<void> loadProviders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final profiles = await _repository.getProviders();
      _providers = profiles.map(_toProviderProfile).toList();
    } catch (_) {
      _providers = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ProviderProfileModel _toProviderProfile(AppProfileModel profile) {
    final serviceKey = profile.specialty.trim().toLowerCase();
    return ProviderProfileModel(
      id: profile.id,
      name: profile.fullName,
      initials: _initials(profile.fullName),
      serviceKey: serviceKey,
      serviceTitle: '${profile.specialty} Service',
      priceRange: 'Contact for pricing',
      location: profile.address,
      experience: 'New provider',
      joinedDate: 'Recently joined',
      status: ProviderStatus.available,
      avatarColor: _avatarColor(profile.id),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }

  Color _avatarColor(String id) {
    const colors = [
      Color(0xFF00C566),
      Color(0xFF0EA5E9),
      Color(0xFF8B5CF6),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }
}
