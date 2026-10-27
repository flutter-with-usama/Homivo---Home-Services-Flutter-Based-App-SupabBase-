import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_service.dart';

/// Manages the Change Password form state.
/// Used by both client and provider profile screens.
///
/// Flow:
///   1. User enters current password (verified by re-authenticating).
///   2. User enters new password + confirmation.
///   3. On save — re-auth with current password, then updateUser with new one.
class ChangePasswordViewModel extends ChangeNotifier {
  // ── Field values ───────────────────────────────────────────────────────────
  String _current  = '';
  String _newPass  = '';
  String _confirm  = '';

  // ── Visibility toggles ─────────────────────────────────────────────────────
  bool _obscureCurrent = true;
  bool _obscureNew     = true;
  bool _obscureConfirm = true;

  // ── State ──────────────────────────────────────────────────────────────────
  bool    _isLoading    = false;
  String? _errorMessage;

  // ── Getters ────────────────────────────────────────────────────────────────
  String  get current        => _current;
  String  get newPass        => _newPass;
  String  get confirm        => _confirm;
  bool    get obscureCurrent => _obscureCurrent;
  bool    get obscureNew     => _obscureNew;
  bool    get obscureConfirm => _obscureConfirm;
  bool    get isLoading      => _isLoading;
  String? get errorMessage   => _errorMessage;

  // ── Password rules ─────────────────────────────────────────────────────────
  bool get ruleMinLength   => _newPass.length >= 8;
  bool get ruleUppercase   => RegExp(r'[A-Z]').hasMatch(_newPass);
  bool get ruleNumber      => RegExp(r'[0-9]').hasMatch(_newPass);
  bool get ruleSpecial     =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(_newPass);
  bool get ruleMatch       =>
      _newPass.isNotEmpty && _newPass == _confirm;

  /// Mismatch hint shown below confirm field only when user has typed something.
  bool get showMismatch =>
      _confirm.isNotEmpty && _newPass != _confirm;

  bool get canSave =>
      _current.isNotEmpty &&
      ruleMinLength &&
      ruleMatch;

  // ── Field actions ──────────────────────────────────────────────────────────
  void onCurrentChanged(String v) {
    _current      = v;
    _errorMessage = null;
    notifyListeners();
  }

  void onNewPassChanged(String v) {
    _newPass      = v;
    _errorMessage = null;
    notifyListeners();
  }

  void onConfirmChanged(String v) {
    _confirm      = v;
    _errorMessage = null;
    notifyListeners();
  }

  void toggleCurrent() {
    _obscureCurrent = !_obscureCurrent;
    notifyListeners();
  }

  void toggleNew() {
    _obscureNew = !_obscureNew;
    notifyListeners();
  }

  void toggleConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  // ── Save ───────────────────────────────────────────────────────────────────
  /// Returns `true` on success, `false` on failure (errorMessage is set).
  Future<bool> save() async {
    if (!canSave) return false;

    _isLoading    = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final auth  = SupabaseService.client.auth;
      final user  = auth.currentUser;

      if (user == null || user.email == null) {
        _errorMessage = 'No authenticated user found. Please log in again.';
        _isLoading    = false;
        notifyListeners();
        return false;
      }

      // Step 1 — re-authenticate with current password to verify it
      final reAuth = await auth.signInWithPassword(
        email:    user.email!,
        password: _current,
      );

      if (reAuth.user == null) {
        _errorMessage = 'Current password is incorrect.';
        _isLoading    = false;
        notifyListeners();
        return false;
      }

      // Step 2 — update to new password
      await auth.updateUser(UserAttributes(password: _newPass));

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading    = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Unexpected error. Please try again.';
      _isLoading    = false;
      notifyListeners();
      return false;
    }
  }
}
