import 'package:flutter/material.dart';
import '../../../data/models/home_model.dart';
import 'service_category_card.dart';

/// 2-per-row grid — cards size themselves, no fixed height constraints.
class ServiceCategoryGrid extends StatelessWidget {
  final List<ServiceModel> services;
  final void Function(ServiceModel)? onServiceTap;

  const ServiceCategoryGrid({
    super.key,
    required this.services,
    this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (int i = 0; i < services.length; i += 2) {
      final hasSecond = i + 1 < services.length;

      rows.add(
        IntrinsicHeight(                      // both cards in a row same height
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ServiceCategoryCard(
                  service: services[i],
                  onTap: () => onServiceTap?.call(services[i]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: hasSecond
                    ? ServiceCategoryCard(
                        service: services[i + 1],
                        onTap: () => onServiceTap?.call(services[i + 1]),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );

      if (i + 2 < services.length) rows.add(const SizedBox(height: 12));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
