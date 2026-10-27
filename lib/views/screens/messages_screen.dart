import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodels/messages_viewmodel.dart';

// ── Components ─────────────────────────────────────────────────────────────────
import '../widgets/messages/conversation_search_bar.dart';
import '../widgets/messages/conversation_list_tile.dart';
import 'chat_screen.dart';

/// Messages screen — list of all conversations with search + New Chat FAB.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
      create: (_) => MessagesViewModel(),
      child: const _MessagesBody(),
    );
  }
}

class _MessagesBody extends StatelessWidget {
  const _MessagesBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MessagesViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,

      // ── App bar ──────────────────────────────────────────────────────────
      appBar: _MessagesAppBar(),

      // ── New Chat FAB — centred at bottom ─────────────────────────────────
      // ── Body ─────────────────────────────────────────────────────────────
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: ConversationSearchBar(onChanged: vm.onSearchChanged),
          ),

          // ── Conversation list ───────────────────────────────────────────
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.errorMessage != null
                ? _ErrorState(message: vm.errorMessage!)
                : vm.conversations.isEmpty
                ? _EmptyState(query: vm.searchQuery)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: vm.conversations.length,
                    separatorBuilder: (_, i) => const Divider(
                      height: 1,
                      indent: 88,
                      endIndent: 20,
                      color: Color(0xFFF0F0F0),
                    ),
                    itemBuilder: (_, i) {
                      final conv = vm.conversations[i];
                      return ConversationListTile(
                        conversation: conv,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatScreen.fromConversation(conversation: conv),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFFEF4444)),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        'Messages',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              ),
              child: const Icon(
                Icons.more_vert_rounded,
                size: 18,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 60,
            color: AppTheme.primaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No conversations yet' : 'No results for "$query"',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Open a provider profile and tap Contact Us to start a chat.',
            style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
