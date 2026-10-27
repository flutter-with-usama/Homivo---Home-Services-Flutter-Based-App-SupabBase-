import '../../core/services/supabase_service.dart';
import '../models/app_profile_model.dart';

class AdminRepository {
  Future<List<AppProfileModel>> getProviders() async {
    final rows = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('role', 'provider')
        .order('specialty')
        .order('full_name');

    return rows.map(AppProfileModel.fromMap).toList();
  }

  Future<void> deleteProvider(String providerId) async {
    await SupabaseService.client.rpc(
      'delete_provider_account',
      params: {'provider_id': providerId},
    );
  }

  Future<void> signOut() => SupabaseService.client.auth.signOut();
}
