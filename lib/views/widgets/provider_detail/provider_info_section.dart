import 'package:flutter/material.dart';
import '../../../data/models/provider_profile_model.dart';
import 'provider_info_row.dart';

/// Card grouping budget + location info rows with a divider between them.
class ProviderInfoSection extends StatelessWidget {
  final ProviderProfileModel provider;

  const ProviderInfoSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Budget row
          ProviderInfoRow(
            icon: Icons.monetization_on_outlined,
            label: 'Estimated budget',
            value: '${provider.priceRange}/monthly',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),

          // Location row
          ProviderInfoRow(
            icon: Icons.work_outline_rounded,
            label: 'Location',
            value: provider.location,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),

          // Experience row
          ProviderInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Experience',
            value: provider.experience,
          ),
        ],
      ),
    );
  }
}
