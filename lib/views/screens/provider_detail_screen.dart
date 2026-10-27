import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/provider_profile_model.dart';
import '../widgets/provider_detail/job_description_section.dart';
import '../widgets/provider_detail/provider_detail_app_bar.dart';
import '../widgets/provider_detail/provider_detail_header.dart';
import '../widgets/provider_detail/provider_info_section.dart';
import 'booking_screen.dart';
import 'chat_screen.dart';

class ProviderDetailScreen extends StatelessWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;

  const ProviderDetailScreen({
    super.key,
    required this.provider,
    required this.serviceColor,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: const ProviderDetailAppBar(),
      bottomNavigationBar: _BottomBar(
        provider: provider,
        serviceColor: serviceColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderDetailHeader(
              provider: provider,
              serviceColor: serviceColor,
            ),
            const SizedBox(height: 24),
            ProviderInfoSection(provider: provider),
            const SizedBox(height: 24),
            JobDescriptionSection(
              description: serviceDescription(provider.serviceKey),
              highlights: serviceHighlights(provider.serviceKey),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final ProviderProfileModel provider;
  final Color serviceColor;

  const _BottomBar({
    required this.provider,
    required this.serviceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Contact Us',
                icon: Icons.chat_bubble_outline_rounded,
                color: serviceColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen.fromProvider(
                      provider: provider,
                      serviceColor: serviceColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: 'Book Now',
                icon: Icons.calendar_month_rounded,
                color: serviceColor,
                isFilled: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      provider: provider,
                      serviceColor: serviceColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isFilled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isFilled ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isFilled ? null : Border.all(color: color, width: 1.8),
          boxShadow: isFilled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isFilled ? Colors.white : color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isFilled ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
