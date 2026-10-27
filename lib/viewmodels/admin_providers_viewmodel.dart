import 'package:flutter/foundation.dart';

import '../data/models/app_profile_model.dart';
import '../data/repositories/admin_repository.dart';

class AdminProvidersViewModel extends ChangeNotifier {
  final _repository = AdminRepository();

  List<AppProfileModel> _providers = const [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _deletingProviderId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get deletingProviderId => _deletingProviderId;
  int get providerCount => _providers.length;

  Map<String, List<AppProfileModel>> get groupedProviders {
    final groups = <String, List<AppProfileModel>>{};
    for (final provider in _providers) {
      final specialty = provider.specialty.trim().isEmpty
          ? 'Other Services'
          : provider.specialty.trim();
      groups.putIfAbsent(specialty, () => []).add(provider);
    }
    return groups;
  }

  Future<void> loadProviders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _providers = await _repository.getProviders();
    } catch (_) {
      _errorMessage = 'Could not load service providers. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProvider(String providerId) async {
    _deletingProviderId = providerId;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteProvider(providerId);
      _providers = _providers.where((p) => p.id != providerId).toList();
      return true;
    } catch (_) {
      _errorMessage = 'Could not delete this provider. Please try again.';
      return false;
    } finally {
      _deletingProviderId = null;
      notifyListeners();
    }
  }

  Future<void> signOut() => _repository.signOut();
}
