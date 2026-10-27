import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/home_model.dart';
import '../../viewmodels/service_providers_viewmodel.dart';
import '../widgets/service/provider_list_tile.dart';
import 'provider_detail_screen.dart';

/// Shows all service providers for a specific [service].
class ServiceProvidersScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceProvidersScreen({super.key, required this.service});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  // ── Create VM locally — no Provider lookup needed ──────────────────────────
  final _vm = ServiceProvidersViewModel();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _vm.addListener(_refresh);
    _vm.loadProviders();
  }

  @override
  void dispose() {
    _vm.removeListener(_refresh);
    _vm.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final allProviders = _vm.getByService(widget.service.name.toLowerCase());

    // Empty search shows all. Typing filters by provider city/location only.
    final filtered = allProviders.where((p) {
      return _searchQuery.isEmpty ||
          p.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        children: [
          // ── Curved header ──────────────────────────────────────────────
          _ServiceHeader(service: widget.service, count: allProviders.length),

          // ── Search + filter bar ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              children: [
                // Search field
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search by city or location...',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppTheme.textGrey,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Provider list ──────────────────────────────────────────────
          Expanded(
            child: _vm.isLoading && filtered.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? _EmptyState(serviceName: widget.service.name)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => ProviderListTile(
                      provider: filtered[i],
                      serviceColor: widget.service.color,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProviderDetailScreen(
                            provider: filtered[i],
                            serviceColor: widget.service.color,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Curved service header ─────────────────────────────────────────────────────
class _ServiceHeader extends StatelessWidget {
  final ServiceModel service;
  final int count;

  const _ServiceHeader({required this.service, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [service.color, service.color.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Icon + title
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(service.icon, color: Colors.white, size: 22),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$count professionals available',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────
// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String serviceName;
  const _EmptyState({required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_search_rounded,
            size: 64,
            color: AppTheme.primaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No $serviceName providers found',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
