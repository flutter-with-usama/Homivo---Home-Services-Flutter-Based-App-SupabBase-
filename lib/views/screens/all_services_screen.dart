import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/home_model.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../widgets/home/service_category_card.dart';
import 'service_providers_screen.dart';

/// Full-screen grid of all 10 services — opened from "See all".
class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final services = context.read<HomeViewModel>().services;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Choose a service to get started',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Services grid ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: _ServicesGrid(services: services),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final List<ServiceModel> services;
  const _ServicesGrid({required this.services});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < services.length; i += 2) {
      final hasSecond = i + 1 < services.length;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ServiceCategoryCard(
                  service: services[i],
                  onTap: () => _navigate(context, services[i]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: hasSecond
                    ? ServiceCategoryCard(
                        service: services[i + 1],
                        onTap: () => _navigate(context, services[i + 1]),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < services.length) rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }

  void _navigate(BuildContext context, ServiceModel service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceProvidersScreen(service: service),
      ),
    );
  }
}
