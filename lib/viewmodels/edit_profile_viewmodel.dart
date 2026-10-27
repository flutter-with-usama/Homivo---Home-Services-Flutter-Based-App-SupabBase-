import 'package:flutter/foundation.dart';
import '../data/models/register_model.dart';
import '../data/repositories/profile_repository.dart';

/// Holds the edit-profile form state.
/// Pre-filled from the current profile; role-aware for specialty field.
class EditProfileViewModel extends ChangeNotifier {
  final _repository = ProfileRepository();

  // ── Initial values (passed in from the profile screen) ────────────────────
  final UserRole role;

  String _fullName;
  String _email;
  String _phone;
  String _address;
  String _specialty;
  bool   _isLoading  = false;
  String? _errorMessage;
  bool   _isSaved    = false;

  EditProfileViewModel({
    required this.role,
    required String fullName,
    required String email,
    required String phone,
    String address   = '',
    String specialty = '',
  })  : _fullName  = fullName,
        _email     = email,
        _phone     = phone,
        _address   = address,
        _specialty = specialty;

  // ── Exposed state ──────────────────────────────────────────────────────────
  String  get fullName     => _fullName;
  String  get email        => _email;
  String  get phone        => _phone;
  String  get address      => _address;
  String  get specialty    => _specialty;
  bool    get isLoading    => _isLoading;
  String? get errorMessage => _errorMessage;
  bool    get isSaved      => _isSaved;
  bool    get isProvider   => role == UserRole.provider;

  bool get canSave =>
      _fullName.trim().isNotEmpty &&
      _email.trim().isNotEmpty &&
      _phone.trim().isNotEmpty &&
      _address.trim().isNotEmpty &&
      (!isProvider || _specialty.trim().isNotEmpty);

  // ── Field actions ──────────────────────────────────────────────────────────
  void onFullNameChanged(String v) {
    _fullName = v;
    _errorMessage = null;
    _isSaved = false;
    notifyListeners();
  }

  void onEmailChanged(String v) {
    _email = v;
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

  void onAddressChanged(String v) {
    _address = v;
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
        address: _address,
        role: role,
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
