import 'package:flutter/foundation.dart';
import '../data/models/register_model.dart';
import '../data/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final _repo = AuthRepository();

  RegisterModel _state;

  /// [role] is passed from the role-selection screen so it's pre-set.
  RegisterViewModel({UserRole role = UserRole.client})
      : _state = RegisterModel(role: role);

  // ── Exposed state ──────────────────────────────────────────────────────────
  String   get fullName          => _state.fullName;
  String   get email             => _state.email;
  String   get phone             => _state.phone;
  String   get address           => _state.address;
  String   get password          => _state.password;
  String   get specialty         => _state.specialty;
  UserRole get role              => _state.role;
  bool     get isProvider        => _state.role == UserRole.provider;
  bool     get isAddressObscured  => _state.isAddressObscured;
  bool     get isPasswordObscured => _state.isPasswordObscured;
  bool     get isLoading         => _state.isLoading;
  String?  get errorMessage      => _state.errorMessage;
  bool     get canSubmit         => _state.canSubmit;

  // ── Field actions ──────────────────────────────────────────────────────────
  void onFullNameChanged(String v) {
    _state = _state.copyWith(fullName: v, errorMessage: null);
    notifyListeners();
  }

  void onEmailChanged(String v) {
    _state = _state.copyWith(email: v, errorMessage: null);
    notifyListeners();
  }

  void onPhoneChanged(String v) {
    _state = _state.copyWith(phone: v, errorMessage: null);
    notifyListeners();
  }

  void onAddressChanged(String v) {
    _state = _state.copyWith(address: v, errorMessage: null);
    notifyListeners();
  }

  void onPasswordChanged(String v) {
    _state = _state.copyWith(password: v, errorMessage: null);
    notifyListeners();
  }

  void onSpecialtyChanged(String v) {
    _state = _state.copyWith(specialty: v, errorMessage: null);
    notifyListeners();
  }

  void toggleAddressVisibility() {
    _state = _state.copyWith(isAddressObscured: !_state.isAddressObscured);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(isPasswordObscured: !_state.isPasswordObscured);
    notifyListeners();
  }

  // ── Register via Supabase ──────────────────────────────────────────────────
  Future<bool> register() async {
    if (!canSubmit) return false;

    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _repo.signUp(
      email:     _state.email.trim(),
      password:  _state.password,
      fullName:  _state.fullName.trim(),
      role:      _state.role,
      phone:     _state.phone.trim(),
      address:   _state.address.trim(),
      specialty: _state.specialty.trim(),
    );

    _state = _state.copyWith(
      isLoading: false,
      errorMessage: result.success ? null : result.errorMessage,
    );
    notifyListeners();

    return result.success;
  }
}
