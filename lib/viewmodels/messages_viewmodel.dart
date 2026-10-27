import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/conversation_model.dart';
import '../data/repositories/chat_repository.dart';

class MessagesViewModel extends ChangeNotifier {
  final _repository = ChatRepository();
  StreamSubscription<List<ConversationModel>>? _subscription;

  List<ConversationModel> _all = const [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  MessagesViewModel() {
    _subscription = _repository.watchConversations().listen(
      (conversations) {
        _all = conversations;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        _errorMessage = 'Could not load conversations. Please try again.';
        notifyListeners();
      },
    );
  }

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<ConversationModel> get conversations {
    if (_searchQuery.trim().isEmpty) return _all;
    final query = _searchQuery.toLowerCase();
    return _all
        .where(
          (conversation) =>
              conversation.name.toLowerCase().contains(query) ||
              conversation.lastMessage.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
