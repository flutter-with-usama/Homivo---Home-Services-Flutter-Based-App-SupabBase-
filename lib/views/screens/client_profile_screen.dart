import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/register_model.dart';
import '../../viewmodels/client_profile_viewmodel.dart';

// ── Components ─────────────────────────────────────────────────────────────────
import '../widgets/profile/profile_header_section.dart';
import '../widgets/profile/profile_stats_row.dart';
import '../widgets/profile/profile_menu_card.dart';
import '../widgets/profile/profile_menu_item.dart';
import '../widgets/profile/profile_logout_button.dart';
import 'help_support_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'change_password_screen.dart';

/// Client profile screen — assembles all profile components.
class ClientProfileScreen extends StatelessWidget {
  /// Called when the user taps "Booking History" to switch to the Bookings tab.
  final ValueChanged<int>? onSwitchTab;

  const ClientProfileScreen({super.key, this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return ChangeNotifierProvider(
      create: (_) => ClientProfileViewModel(),
      child: _ProfileBody(onSwitchTab: onSwitchTab),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ValueChanged<int>? onSwitchTab;
  const _ProfileBody({this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClientProfileViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.bgPage,

      // ── App bar ──────────────────────────────────────────────────────────
      appBar: const _ProfileAppBar(),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Green curved header ─────────────────────────────────
            ProfileHeaderSection(
              initials: vm.initials,
              fullName: vm.fullName,
              email: vm.email,
              phone: vm.phone,
            ),

            // ── 2. Stats row — overlaps header bottom ──────────────────
            Transform.translate(
              offset: const Offset(0, -28),
              child: ProfileStatsRow(
                totalBookings: vm.totalBookings,
                completedBookings: vm.completedBookings,
              ),
            ),

            // ── 3. Account Settings card ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ProfileMenuCard(
                title: 'Account Settings',
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                    iconColor: const Color(0xFF3B82F6),
                    iconBgColor: const Color(0xFFEFF6FF),
                    onTap: () => _openEditProfile(context, vm),
                  ),
                  ProfileMenuItem(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    iconColor: AppTheme.primary,
                    iconBgColor: AppTheme.primaryLight,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(
                          accentColor: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    iconColor: AppTheme.amber,
                    iconBgColor: AppTheme.amberLight,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    iconColor: AppTheme.textGrey,
                    iconBgColor: const Color(0xFFF3F4F6),
                    showDivider: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 4. Booking History card ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProfileMenuCard(
                children: [
                  ProfileMenuItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Booking History',
                    subtitle: 'View all past bookings',
                    iconColor: const Color(0xFF3B82F6),
                    iconBgColor: const Color(0xFFEFF6FF),
                    showDivider: false,
                    onTap: () {
                      // Switch to the Bookings tab (index 1) in the main nav
                      onSwitchTab?.call(1);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 5. Logout ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProfileLogoutButton(
                onTap: () async {
                  await vm.logout();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamedAndRemoveUntil('/login', (_) => false);
                  }
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditProfile(
    BuildContext context,
    ClientProfileViewModel vm,
  ) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          role: UserRole.client,
          fullName: vm.fullName,
          email: vm.email,
          phone: vm.phone,
          address: vm.address,
          initials: vm.initials,
        ),
      ),
    );
    if (updated == true) await vm.loadProfile();
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

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
        'My Profile',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}
