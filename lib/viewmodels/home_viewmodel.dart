import 'package:flutter/material.dart';
import '../data/models/home_model.dart';
import '../data/repositories/profile_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final _profileRepository = ProfileRepository();

  HomeViewModel() {
    loadProfile();
  }

  // ── User state ─────────────────────────────────────────────────────────────
  String userName = '';

  Future<void> loadProfile() async {
    final cachedProfile = _profileRepository.getCachedProfile();
    if (cachedProfile != null) {
      userName = cachedProfile.fullName;
      notifyListeners();
    }

    try {
      userName = (await _profileRepository.getCurrentProfile()).fullName;
      notifyListeners();
    } catch (_) {
      // Keep cached profile data visible while offline.
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ── Promo banners ──────────────────────────────────────────────────────────
  // ── Services (10 total) — all use brand green for consistency ────────────
  final List<ServiceModel> services = const [
    ServiceModel(
      name: 'Plumbing',
      icon: Icons.plumbing_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
      imageAsset: 'assets/images/plumbing-logo.png',
    ),
    ServiceModel(
      name: 'Electrical',
      icon: Icons.bolt_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Carpentry',
      icon: Icons.carpenter_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Cleaning',
      icon: Icons.cleaning_services_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Appliance Repair',
      icon: Icons.home_repair_service_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Painting',
      icon: Icons.format_paint_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Landscaping',
      icon: Icons.grass_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Pest Control',
      icon: Icons.pest_control_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'HVAC',
      icon: Icons.air_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
    ServiceModel(
      name: 'Roofing',
      icon: Icons.roofing_rounded,
      color: Color(0xFF00C566),
      iconBgColor: Color(0xFFD0F5E8),
    ),
  ];
}
