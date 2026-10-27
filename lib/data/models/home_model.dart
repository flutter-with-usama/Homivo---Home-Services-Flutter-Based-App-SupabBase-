import 'package:flutter/material.dart';

/// Represents a single home service category.
class ServiceModel {
  final String name;
  final IconData icon;
  final Color color;
  final Color iconBgColor;
  final String? imageAsset;

  const ServiceModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.iconBgColor,
    this.imageAsset,
  });
}

/// Represents a quick-action card on the home screen.
class QuickActionModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const QuickActionModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
