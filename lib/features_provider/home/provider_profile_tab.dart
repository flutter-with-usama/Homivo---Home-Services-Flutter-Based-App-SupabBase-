import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodels/provider_dashboard_viewmodel.dart';
import '../../views/widgets/provider/stats_row_widget.dart';
import '../../views/screens/change_password_screen.dart';
import 'provider_edit_profile_screen.dart';
import 'provider_notifications_screen.dart';
import 'provider_help_support_screen.dart';

/// Profile tab for the provider side.
class ProviderProfileTab extends StatelessWidget {
  const ProviderProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final vm = context.watch<ProviderDashboardViewModel>();

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: const _ProfileAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          children: [
            // ── Avatar ─────────────────────────────────────────────────
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.deepPurple, AppTheme.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.deepPurple.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      vm.providerInitials,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Edit badge
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => _openEditProfile(context, vm),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.deepPurple,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 13,
                        color: AppTheme.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Name ───────────────────────────────────────────────────
            Text(
              vm.providerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),

            // ── Specialty pill ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.deepPurpleLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                vm.providerSpecialty,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // ── Contact info pills ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: _InfoPill(
                    icon: Icons.phone_outlined,
                    label: vm.providerPhone,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: _InfoPill(
                    icon: Icons.location_on_outlined,
                    label: vm.providerArea,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ── Stats row ──────────────────────────────────────────────
            StatsRowWidget(
              activeJobs: vm.earnings.activeJobs,
              pendingJobs: vm.earnings.pendingJobs,
              completedJobs: vm.earnings.completedJobs,
            ),
            const SizedBox(height: 24),

            // ── Menu items ─────────────────────────────────────────────
            _ProfileMenuItem(
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              onTap: () => _openEditProfile(context, vm),
            ),
            _ProfileMenuItem(
              icon: Icons.lock_outline_rounded,
              label: 'Change Password',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(
                    accentColor: AppTheme.deepPurple,
                  ),
                ),
              ),
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProviderNotificationsScreen(),
                ),
              ),
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline_rounded,
              label: 'Help & Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProviderHelpSupportScreen(),
                ),
              ),
            ),
            _ProfileMenuItem(
              icon: Icons.logout_rounded,
              label: 'Log Out',
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
          ],
        ),
      ),
    );
  }

  void _openEditProfile(
    BuildContext context,
    ProviderDashboardViewModel vm,
  ) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderEditProfileScreen(
          fullName: vm.providerName,
          email: vm.providerEmail,
          phone: vm.providerPhone,
          serviceArea: vm.providerArea,
          specialty: vm.providerSpecialty,
          initials: vm.providerInitials,
        ),
      ),
    );

    // If the user saved, update the viewmodel so the profile tab reflects changes
    // The actual updated values come back via the screen's own VM —
    // for now the snackbar confirms success; a real app would re-fetch from DB.
    if (updated == true && context.mounted) {
      await vm.loadProfile();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated ✅'),
          backgroundColor: AppTheme.deepPurple,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
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

// ── Info pill ─────────────────────────────────────────────────────────────────
class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textGrey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ProfileMenuItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLogout = label == 'Log Out';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isLogout
                ? const Color(0xFFFEE2E2)
                : AppTheme.deepPurpleLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isLogout ? const Color(0xFFEF4444) : AppTheme.deepPurple,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isLogout ? const Color(0xFFEF4444) : const Color(0xFF1A1A2E),
          ),
        ),
        trailing: isLogout
            ? null
            : const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textGrey,
                size: 20,
              ),
        onTap: onTap,
      ),
    );
  }
}
