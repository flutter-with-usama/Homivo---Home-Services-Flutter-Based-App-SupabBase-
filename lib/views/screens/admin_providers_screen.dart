import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/app_profile_model.dart';
import '../../viewmodels/admin_providers_viewmodel.dart';

class AdminProvidersScreen extends StatelessWidget {
  const AdminProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminProvidersViewModel()..loadProviders(),
      child: const _AdminProvidersBody(),
    );
  }
}

class _AdminProvidersBody extends StatelessWidget {
  const _AdminProvidersBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminProvidersViewModel>();
    final groups = vm.groupedProviders;

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: AppBar(
        title: const Text('Service Providers'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: vm.isLoading ? null : vm.loadProviders,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: () async {
              await vm.signOut();
              if (context.mounted) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.loadProviders,
        child: vm.isLoading && groups.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  _SummaryCard(providerCount: vm.providerCount),
                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    _ErrorBanner(message: vm.errorMessage!),
                  ],
                  const SizedBox(height: 16),
                  if (groups.isEmpty)
                    const _EmptyState()
                  else
                    ...groups.entries.map(
                      (entry) => _SpecialtySection(
                        specialty: entry.key,
                        providers: entry.value,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int providerCount;

  const _SummaryCard({required this.providerCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.deepPurple, Color(0xFF5E35B1)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '$providerCount registered service providers',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SpecialtySection extends StatelessWidget {
  final String specialty;
  final List<AppProfileModel> providers;

  const _SpecialtySection({required this.specialty, required this.providers});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          '$specialty (${providers.length})',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        children: providers
            .map((provider) => _ProviderTile(provider: provider))
            .toList(),
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final AppProfileModel provider;

  const _ProviderTile({required this.provider});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminProvidersViewModel>();
    final isDeleting = vm.deletingProviderId == provider.id;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.deepPurpleLight,
        child: Text(
          _initials(provider.fullName),
          style: const TextStyle(
            color: AppTheme.deepPurple,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(provider.fullName),
      subtitle: Text(
        '${provider.email}\n${provider.phone} | ${provider.address}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: isDeleting
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              tooltip: 'Delete provider',
              onPressed: () => _confirmDelete(context, provider),
              icon: const Icon(Icons.delete_outline_rounded),
              color: const Color(0xFFEF4444),
            ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppProfileModel provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete provider?'),
        content: Text(
          'This permanently deletes ${provider.fullName} and their login account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<AdminProvidersViewModel>().deleteProvider(provider.id);
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'P';
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: const TextStyle(color: Color(0xFFEF4444))),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Center(
        child: Text(
          'No service providers found.',
          style: TextStyle(color: AppTheme.textGrey),
        ),
      ),
    );
  }
}
