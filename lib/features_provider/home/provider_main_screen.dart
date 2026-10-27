import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../viewmodels/provider_dashboard_viewmodel.dart';
import '../../views/screens/messages_screen.dart';
import 'provider_home_provider.dart';
import 'provider_home_view.dart';
import 'provider_dashboard_tab.dart';
import 'provider_profile_tab.dart';

/// Root shell for the provider side.
/// Holds a 4-tab bottom navigation bar:
///   0 – Home  |  1 – Messages  |  2 – Dashboard  |  3 – Profile
/// Each tab gets its own [Navigator] so pushes/pops stay within the tab
/// and the bottom nav always remains visible.
class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() => _ProviderMainScreenState();
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
  int _currentIndex = 0;
  final _notificationRepository = NotificationRepository();
  StreamSubscription<List<NotificationModel>>? _notificationSubscription;
  OverlayEntry? _notificationOverlay;
  final Set<String> _seenNotificationIds = {};
  bool _hasLoadedNotifications = false;

  @override
  void initState() {
    super.initState();
    _watchNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProviderDashboardViewModel>().loadProfile();
    });
  }

  @override
  void dispose() {
    _notificationOverlay?.remove();
    _notificationOverlay = null;
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _watchNotifications() {
    _notificationSubscription = _notificationRepository
        .watchCurrentUserNotifications()
        .listen(_handleNotifications, onError: (_) {});
  }

  void _handleNotifications(List<NotificationModel> notifications) {
    final notificationIds = notifications.map((n) => n.id).toSet();
    final newNotifications = notifications
        .where(
          (notification) =>
              !notification.isRead &&
              !_seenNotificationIds.contains(notification.id),
        )
        .toList();

    _seenNotificationIds
      ..clear()
      ..addAll(notificationIds);

    if (!_hasLoadedNotifications) {
      _hasLoadedNotifications = true;
      return;
    }

    if (newNotifications.isNotEmpty && mounted) {
      _showNotificationPopup(newNotifications.first);
    }
  }

  void _showNotificationPopup(NotificationModel notification) {
    _notificationOverlay?.remove();
    final entry = OverlayEntry(
      builder: (context) {
        final top = MediaQuery.of(context).padding.top + 12;
        return Positioned(
          top: top,
          left: 16,
          right: 16,
          child: _NotificationPopupCard(notification: notification),
        );
      },
    );
    _notificationOverlay = entry;

    Overlay.of(context, rootOverlay: true).insert(entry);
    Future.delayed(const Duration(seconds: 4), () {
      if (_notificationOverlay == entry) {
        entry.remove();
        _notificationOverlay = null;
      }
    });
  }

  // One GlobalKey per tab so each keeps its own navigation stack.
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return ChangeNotifierProvider(
      create: (_) => ProviderHomeProvider(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          final nav = _navigatorKeys[_currentIndex].currentState;
          if (nav != null && nav.canPop()) nav.pop();
        },
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              // 0 – Home
              _TabNavigator(
                navigatorKey: _navigatorKeys[0],
                child: const ProviderHomeView(),
              ),
              // 1 – Messages
              _TabNavigator(
                navigatorKey: _navigatorKeys[1],
                child: const MessagesScreen(),
              ),
              // 2 – Dashboard
              _TabNavigator(
                navigatorKey: _navigatorKeys[2],
                child: const ProviderDashboardTab(),
              ),
              // 3 – Profile
              _TabNavigator(
                navigatorKey: _navigatorKeys[3],
                child: const ProviderProfileTab(),
              ),
            ],
          ),
          bottomNavigationBar: _ProviderBottomNav(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        ),
      ),
    );
  }
}

/// Wraps a tab root widget in its own [Navigator] so each tab has an
/// independent navigation stack.
class _TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const _TabNavigator({required this.navigatorKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
    );
  }
}

// ── Bottom navigation bar ─────────────────────────────────────────────────────
class _NotificationPopupCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationPopupCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: notification.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ProviderBottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Messages'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(
              _items.length,
              (i) => Expanded(
                child: _NavTile(
                  item: _items[i],
                  isSelected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 5 : 0,
              height: isSelected ? 5 : 0,
              margin: EdgeInsets.only(bottom: isSelected ? 4 : 0),
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? AppTheme.primary : AppTheme.textGrey,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppTheme.primary : AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
