import 'package:flutter/foundation.dart';
import '../data/models/login_model.dart';
import '../data/models/register_model.dart';
import '../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final _repo = AuthRepository();

  LoginModel _state = const LoginModel();

  // ── Exposed state ──────────────────────────────────────────────────────────
  String   get email             => _state.email;
  String   get password          => _state.password;
  bool     get isPasswordObscured => _state.isPasswordObscured;
  bool     get isLoading         => _state.isLoading;
  String?  get errorMessage      => _state.errorMessage;

  bool get canSubmit =>
      _state.email.trim().isNotEmpty && _state.password.isNotEmpty;

  // ── Field actions ──────────────────────────────────────────────────────────
  void onEmailChanged(String value) {
    _state = _state.copyWith(email: value, errorMessage: null);
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _state = _state.copyWith(password: value, errorMessage: null);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(isPasswordObscured: !_state.isPasswordObscured);
    notifyListeners();
  }

  // ── Login via Supabase — returns role on success, null on failure ──────────
  Future<UserRole?> login() async {
    if (!canSubmit) return null;

    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _repo.signIn(
      email:    _state.email.trim(),
      password: _state.password,
    );

    _state = _state.copyWith(
      isLoading: false,
      errorMessage: result.success ? null : result.errorMessage,
    );
    notifyListeners();

    return result.success ? (result.role ?? UserRole.client) : null;
  }

  // ── Google sign-in — returns role on success, null on failure ────────────
  Future<UserRole?> loginWithGoogle() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _repo.signInWithGoogle();

    _state = _state.copyWith(
      isLoading: false,
      errorMessage: result.success ? null : result.errorMessage,
    );
    notifyListeners();

    return result.success ? (result.role ?? UserRole.client) : null;
  }
}
