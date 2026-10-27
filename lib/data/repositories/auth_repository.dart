import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/services/supabase_service.dart';
import '../models/register_model.dart';

/// Result wrapper — avoids throwing exceptions into the UI layer.
class AuthResult {
  final bool success;
  final String? errorMessage;
  final User? user;
  final UserRole? role; // populated after sign-in

  const AuthResult._({
    required this.success,
    this.errorMessage,
    this.user,
    this.role,
  });

  factory AuthResult.ok(User user, {UserRole? role}) =>
      AuthResult._(success: true, user: user, role: role);

  factory AuthResult.fail(String message) =>
      AuthResult._(success: false, errorMessage: message);
}

/// Handles all Supabase Auth + profile operations.
/// ViewModels call this — they never import supabase_flutter directly.
class AuthRepository {
  final _auth = SupabaseService.client.auth;
  final _db   = SupabaseService.client;

  // ── Sign up ────────────────────────────────────────────────────────────────
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String phone = '',
    String address = '',
    String specialty = '',
  }) async {
    try {
      // 1. Create auth user — store role in metadata for quick access
      final res = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'address': address,
          'role': role.name,
          'specialty': specialty,
        },
      );

      if (res.user == null) {
        return AuthResult.fail('Sign-up failed. Please try again.');
      }

      // 2. Insert profile row (non-blocking — best effort)
      try {
        await _db.from('profiles').upsert({
          'id':        res.user!.id,
          'full_name': fullName,
          'email':     email,
          'phone':     phone,
          'address':   address,
          'role':      role.name,
          'specialty': specialty,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {
        // Profile insert failure doesn't block auth — user can update later
      }

      return AuthResult.ok(res.user!, role: role);
    } on AuthException catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    } catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    }
  }

  // ── Sign in ────────────────────────────────────────────────────────────────
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return AuthResult.fail('Invalid credentials.');
      }

      // Fetch role from user metadata (fastest — no extra DB call)
      final roleStr = res.user!.userMetadata?['role'] as String?;
      final role = _parseRole(roleStr);

      // Fallback: query profiles table if metadata missing
      if (role == null) {
        try {
          final profile = await _db
              .from('profiles')
              .select('role')
              .eq('id', res.user!.id)
              .maybeSingle();
          final dbRole = _parseRole(profile?['role'] as String?);
          return AuthResult.ok(res.user!, role: dbRole ?? UserRole.client);
        } catch (_) {
          return AuthResult.ok(res.user!, role: UserRole.client);
        }
      }

      return AuthResult.ok(res.user!, role: role);
    } on AuthException catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    } catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    }
  }

  // ── Google Sign-In ─────────────────────────────────────────────────────────
  Future<AuthResult> signInWithGoogle() async {
    try {
      // 1. Trigger the Google sign-in flow
      final googleUser = await GoogleSignIn(
        scopes: ['email', 'profile'],
      ).signIn();

      if (googleUser == null) {
        // User cancelled the picker
        return AuthResult.fail('Google sign-in was cancelled.');
      }

      // 2. Get the auth tokens
      final googleAuth = await googleUser.authentication;
      final idToken     = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return AuthResult.fail('Could not get Google ID token.');
      }

      // 3. Sign in to Supabase with the Google tokens
      final res = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken:     idToken,
        accessToken: accessToken,
      );

      if (res.user == null) {
        return AuthResult.fail('Google sign-in failed. Please try again.');
      }

      // 4. Fetch or create profile row
      final roleStr = res.user!.userMetadata?['role'] as String?;
      UserRole role = _parseRole(roleStr) ?? UserRole.client;

      // If new Google user — upsert a profile row with default client role
      try {
        final existing = await _db
            .from('profiles')
            .select('role')
            .eq('id', res.user!.id)
            .maybeSingle();

        if (existing == null) {
          // First-time Google sign-in — create profile
          await _db.from('profiles').upsert({
            'id':        res.user!.id,
            'full_name': googleUser.displayName ?? '',
            'email':     googleUser.email,
            'role':      UserRole.client.name,
            'created_at': DateTime.now().toIso8601String(),
          });
          role = UserRole.client;
        } else {
          role = _parseRole(existing['role'] as String?) ?? UserRole.client;
        }
      } catch (_) {
        // Non-blocking
      }

      return AuthResult.ok(res.user!, role: role);
    } on AuthException catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    } catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    }
  }

  // ── Sign out ───────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Password reset — sends OTP via resetPasswordForEmail ─────────────────
  Future<AuthResult> sendPasswordResetOtp(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
      return const AuthResult._(success: true);
    } on AuthException catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    } catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    }
  }

  // ── Verify OTP (recovery) + set new password ───────────────────────────────
  Future<AuthResult> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // Verify the recovery token from the Reset Password email
      final res = await _auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.recovery,
      );
      if (res.user == null) {
        return AuthResult.fail('Invalid or expired code. Please try again.');
      }

      // Update password while session is active
      await _auth.updateUser(UserAttributes(password: newPassword));

      // Sign out so user logs in fresh
      await _auth.signOut();

      return AuthResult.ok(res.user!);
    } on AuthException catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    } catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    }
  }

  // ── Legacy ─────────────────────────────────────────────────────────────────
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
      return const AuthResult._(success: true);
    } on AuthException catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    } catch (e) {
      return AuthResult.fail(_friendlyUnexpectedError(e));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  UserRole? _parseRole(String? raw) {
    if (raw == null) return null;
    return UserRole.values.firstWhere(
      (r) => r.name == raw,
      orElse: () => UserRole.client,
    );
  }

  String _friendlyUnexpectedError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('network is unreachable') ||
        message.contains('connection refused')) {
      return 'Unable to connect. Check your internet connection and try again.';
    }
    if (error is AuthException) return error.message;
    return 'Something went wrong. Please try again.';
  }

  User?     get currentUser => SupabaseService.currentUser;
  bool      get isSignedIn  => currentUser != null;
}
