import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodels/notifications_viewmodel.dart';
import '../widgets/notifications/notification_tile.dart';
import '../widgets/notifications/notification_group_header.dart';

/// Notifications screen — grouped list with mark-all-read + swipe-to-dismiss.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
      create: (_) => NotificationsViewModel(),
      child: const _NotificationsBody(),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationsViewModel>();
    final grouped = vm.grouped;

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: _NotificationsAppBar(
        unreadCount: vm.unreadCount,
        onMarkAllRead: vm.markAllRead,
        onClearAll: () => _confirmClearAll(context, vm),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? _ErrorState(message: vm.errorMessage!)
          : vm.all.isEmpty
          ? const _EmptyState()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                for (final entry in grouped.entries) ...[
                  // ── Group header ─────────────────────────────────────
                  NotificationGroupHeader(
                    label: entry.key,
                    count: entry.value.length,
                  ),

                  // ── Notification tiles ───────────────────────────────
                  ...entry.value.map(
                    (n) => NotificationTile(
                      notification: n,
                      onTap: () => vm.markRead(n.id),
                      onDismiss: () => vm.remove(n.id),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ],
            ),
    );
  }

  void _confirmClearAll(BuildContext context, NotificationsViewModel vm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        content: const Text(
          'This will permanently remove all notifications. This action cannot be undone.',
          style: TextStyle(fontSize: 13, color: AppTheme.textGrey, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              vm.clearAll();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;
  final VoidCallback onClearAll;

  const _NotificationsAppBar({
    required this.unreadCount,
    required this.onMarkAllRead,
    required this.onClearAll,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Color(0xFF1A1A2E),
            size: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onSelected: (val) {
            if (val == 'read') onMarkAllRead();
            if (val == 'clear') onClearAll();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'read',
              child: Row(
                children: [
                  Icon(
                    Icons.done_all_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text('Mark all as read', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFEF4444),
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Clear all',
                    style: TextStyle(fontSize: 13, color: Color(0xFFEF4444)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
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
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              color: AppTheme.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "You're all caught up!\nWe'll notify you when something happens.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textGrey,
              height: 1.55,
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
