import '../../core/services/supabase_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ChatRepository {
  Future<String> openProviderChat(String providerId) async {
    final id = await SupabaseService.client.rpc(
      'open_provider_chat',
      params: {'target_provider_id': providerId},
    );
    return id as String;
  }

  /// Opens (or retrieves) a conversation between the current provider
  /// and the given client. Calls the [open_client_chat] Supabase RPC.
  Future<String> openClientChat(String clientId) async {
    final id = await SupabaseService.client.rpc(
      'open_client_chat',
      params: {'target_client_id': clientId},
    );
    return id as String;
  }

  Stream<List<ChatMessageModel>> watchMessages(String conversationId) {
    final user = SupabaseService.currentUser;
    if (user == null) return Stream.error(StateError('Please log in again.'));

    return SupabaseService.client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((rows) {
          final messages = rows
              .map((row) => ChatMessageModel.fromMap(row, user.id))
              .toList();
          messages.sort((a, b) {
            final createdCompare = a.createdAt.compareTo(b.createdAt);
            if (createdCompare != 0) return createdCompare;
            return a.id.compareTo(b.id);
          });
          return messages;
        });
  }

  Stream<List<ConversationModel>> watchConversations() {
    final user = SupabaseService.currentUser;
    if (user == null) return Stream.error(StateError('Please log in again.'));

    return SupabaseService.client
        .from('chat_conversations')
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false)
        .map(
          (rows) => rows
              .map((row) => ConversationModel.fromMap(row, user.id))
              .toList(),
        );
  }

  Future<void> sendMessage(String conversationId, String body) async {
    final user = SupabaseService.currentUser;
    if (user == null) throw StateError('Please log in again.');

    await SupabaseService.client.from('chat_messages').insert({
      'conversation_id': conversationId,
      'sender_id': user.id,
      'body': body.trim(),
    });
  }
}
