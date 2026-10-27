import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Custom bottom navigation bar for the provider dashboard.
/// 4 tabs: Home, Messages, Dashboard, Profile.
class ProviderBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const ProviderBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded,                  label: 'Home'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded,   label: 'Messages'),
    _NavItem(icon: Icons.dashboard_rounded,             label: 'Dashboard'),
    _NavItem(icon: Icons.person_outline_rounded,        label: 'Profile'),
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
                  isSelected: i == selectedIndex,
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
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppTheme.primary : AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
