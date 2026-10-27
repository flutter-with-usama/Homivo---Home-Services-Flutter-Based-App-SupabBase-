import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/chat_message_model.dart';
import '../data/repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final String? initialConversationId;
  final String? providerId;
  final _repository = ChatRepository();

  StreamSubscription<List<ChatMessageModel>>? _subscription;
  List<ChatMessageModel> _messages = const [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _conversationId;
  String? _errorMessage;

  ChatViewModel({this.initialConversationId, this.providerId}) {
    _initialize();
  }

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Future<void> _initialize() async {
    try {
      _conversationId =
          initialConversationId ??
          await _repository.openProviderChat(providerId!);
      _subscription = _repository
          .watchMessages(_conversationId!)
          .listen(
            (messages) {
              _messages = messages;
              _isLoading = false;
              _errorMessage = null;
              notifyListeners();
            },
            onError: (_) {
              _isLoading = false;
              _errorMessage = 'Could not load messages. Please try again.';
              notifyListeners();
            },
          );
    } catch (_) {
      _isLoading = false;
      _errorMessage = 'Could not open this chat. Please try again.';
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (_conversationId == null || text.trim().isEmpty || _isSending) return;
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendMessage(_conversationId!, text);
    } catch (_) {
      _errorMessage = 'Could not send your message. Please try again.';
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
