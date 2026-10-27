import 'package:flutter/foundation.dart';
import '../data/models/register_model.dart';
import '../data/repositories/profile_repository.dart';

/// Holds the provider's editable profile state.
/// Only exposes fields that were entered at registration:
///   fullName · email (read-only) · phone · serviceArea · specialty
class ProviderEditProfileViewModel extends ChangeNotifier {
  final _repository = ProfileRepository();

  String _fullName;
  final String email; // read-only — cannot be changed after registration
  String _phone;
  String _serviceArea;
  String _specialty;

  bool    _isLoading    = false;
  String? _errorMessage;
  bool    _isSaved      = false;

  ProviderEditProfileViewModel({
    required String fullName,
    required this.email,
    required String phone,
    required String serviceArea,
    required String specialty,
  })  : _fullName    = fullName,
        _phone       = phone,
        _serviceArea = serviceArea,
        _specialty   = specialty;

  // ── Getters ────────────────────────────────────────────────────────────────
  String  get fullName     => _fullName;
  String  get phone        => _phone;
  String  get serviceArea  => _serviceArea;
  String  get specialty    => _specialty;
  bool    get isLoading    => _isLoading;
  String? get errorMessage => _errorMessage;
  bool    get isSaved      => _isSaved;

  /// Initials derived from the current full name.
  String get initials {
    final parts = _fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return _fullName.isNotEmpty ? _fullName[0].toUpperCase() : 'P';
  }

  bool get canSave =>
      _fullName.trim().isNotEmpty &&
      _phone.trim().isNotEmpty &&
      _serviceArea.trim().isNotEmpty &&
      _specialty.trim().isNotEmpty;

  // ── Field actions ──────────────────────────────────────────────────────────
  void onFullNameChanged(String v) {
    _fullName = v;
    _errorMessage = null;
    _isSaved = false;
    notifyListeners();
  }

  void onPhoneChanged(String v) {
    _phone = v;
    _errorMessage = null;
    _isSaved = false;
    notifyListeners();
  }

  void onServiceAreaChanged(String v) {
    _serviceArea = v;
    _errorMessage = null;
    _isSaved = false;
    notifyListeners();
  }

  void onSpecialtyChanged(String v) {
    _specialty = v;
    _errorMessage = null;
    _isSaved = false;
    notifyListeners();
  }

  // ── Save ───────────────────────────────────────────────────────────────────
  Future<bool> save() async {
    if (!canSave) return false;

    _isLoading    = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateCurrentProfile(
        fullName: _fullName,
        phone: _phone,
        address: _serviceArea,
        role: UserRole.provider,
        specialty: _specialty,
      );
      _isLoading = false;
      _isSaved   = true;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      _errorMessage = 'Could not update profile. Please try again.';
      notifyListeners();
      return false;
    }
  }
}
