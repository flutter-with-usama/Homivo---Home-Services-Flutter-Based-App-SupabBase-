import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around the Supabase client.
/// All repositories and view-models access Supabase through this class,
/// keeping the rest of the codebase decoupled from the SDK directly.
class SupabaseService {
  SupabaseService._();

  /// The initialised Supabase client — available after [Supabase.initialize].
  static SupabaseClient get client => Supabase.instance.client;

  /// Convenience getter for the current authenticated user (nullable).
  static User? get currentUser => client.auth.currentUser;

  /// Auth state stream — listen to sign-in / sign-out events.
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
