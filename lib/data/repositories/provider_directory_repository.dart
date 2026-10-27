import '../../core/services/supabase_service.dart';
import '../models/app_profile_model.dart';

class ProviderDirectoryRepository {
  Future<List<AppProfileModel>> getProviders() async {
    final rows = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('role', 'provider')
        .order('created_at', ascending: false);

    return rows.map(AppProfileModel.fromMap).toList();
  }
}
