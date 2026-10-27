import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/home_viewmodel.dart';
import '../widgets/home/home_header_section.dart';
import '../widgets/home/section_title.dart';
import '../widgets/home/service_category_grid.dart';
import 'service_providers_screen.dart';

/// Homivo Home Screen — assembles all home components.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    // Force dark status bar icons over the green header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Green curved header (handles SafeArea internally) ───────
          HomeHeaderSection(greeting: vm.greeting, userName: vm.userName),

          // ── 2. Scrollable content ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Promo banner ─────────────────────────────────────
                  // ── Our Services (2 per row) ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Our Services'),
                        const SizedBox(height: 14),
                        ServiceCategoryGrid(
                          services: vm.services.take(6).toList(),
                          onServiceTap: (service) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ServiceProvidersScreen(service: service),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // FAB clearance
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
