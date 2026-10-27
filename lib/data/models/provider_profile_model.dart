import 'package:flutter/material.dart';

/// Availability status of a service provider.
enum ProviderStatus { available, busy, completed }

/// A single service provider / employee profile.
class ProviderProfileModel {
  final String id;
  final String name;
  final String initials;
  final String serviceKey;
  final String serviceTitle;
  final String priceRange;
  final String location;
  final String experience;
  final String joinedDate;
  final ProviderStatus status;
  final Color avatarColor;

  // ── Detail screen extras ───────────────────────────────────────────────────
  final List<String> tags;
  final String jobDescription;
  final List<String> highlights;

  const ProviderProfileModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.serviceKey,
    required this.serviceTitle,
    required this.priceRange,
    required this.location,
    required this.experience,
    required this.joinedDate,
    required this.status,
    required this.avatarColor,
    this.tags = const ['Fulltime', 'On-site working', 'Hourly'],
    this.jobDescription = _defaultDescription,
    this.highlights = _defaultHighlights,
  });

  // ── Real default description (used when no custom one is provided) ─────────
  static const String _defaultDescription =
      'Our certified professional will arrive at your home fully equipped '
      'to diagnose and resolve the issue efficiently. We use only '
      'high-quality materials and follow industry safety standards to '
      'ensure lasting results and your complete satisfaction.';

  static const List<String> _defaultHighlights = [
    'Licensed and fully insured professional',
    'Same-day and emergency appointments available',
    'Transparent pricing with no hidden charges',
    'Work guaranteed — free re-visit if issue persists',
    'Clean worksite — we tidy up after every job',
  ];
}

// ── Service-specific descriptions & highlights ────────────────────────────────

/// Returns a real job description tailored to the given service key.
String serviceDescription(String serviceKey) {
  return switch (serviceKey.toLowerCase()) {
    'plumbing' =>
      'Our licensed plumber handles everything from leaky faucets and '
      'blocked drains to full pipe replacements and bathroom installations. '
      'We use modern diagnostic tools to locate issues fast and fix them '
      'right the first time, minimising disruption to your home.',
    'electrical' =>
      'Our certified electrician covers fault finding, wiring upgrades, '
      'consumer unit replacements, socket and lighting installations, and '
      'full electrical safety inspections. All work is carried out to '
      'current wiring regulations with a completion certificate provided.',
    'carpentry' =>
      'From bespoke fitted wardrobes and kitchen cabinets to door hanging, '
      'skirting boards, and structural timber repairs, our skilled carpenter '
      'brings precision craftsmanship to every project. We work with both '
      'hardwood and softwood to match your existing décor perfectly.',
    'cleaning' =>
      'Our professional cleaning team delivers a thorough deep clean of '
      'your entire home using eco-friendly, non-toxic products. We cover '
      'kitchens, bathrooms, living areas, and bedrooms, leaving every '
      'surface spotless and your home smelling fresh.',
    'appliance repair' =>
      'Our appliance technician diagnoses and repairs all major household '
      'appliances including washing machines, dishwashers, ovens, fridges, '
      'and dryers. We carry a wide range of spare parts to complete most '
      'repairs in a single visit, saving you time and money.',
    'painting' =>
      'Our experienced painter and decorator transforms interiors and '
      'exteriors with a flawless finish. We handle surface preparation, '
      'priming, and application of premium paints, ensuring clean edges, '
      'even coverage, and a result that lasts for years.',
    'landscaping' =>
      'Our landscaping expert designs and maintains beautiful outdoor '
      'spaces tailored to your lifestyle. Services include lawn care, '
      'hedge trimming, planting, paving, and seasonal garden clearances '
      'to keep your garden looking its best year-round.',
    'pest control' =>
      'Our pest control specialist uses safe, targeted treatments to '
      'eliminate insects, rodents, and other unwanted pests from your '
      'home. We identify entry points, treat the infestation, and provide '
      'prevention advice to stop the problem from returning.',
    'hvac' =>
      'Our HVAC engineer installs, services, and repairs heating, '
      'ventilation, and air conditioning systems. Whether it is a boiler '
      'breakdown, AC recharge, or a full system installation, we ensure '
      'your home stays comfortable in every season.',
    'roofing' =>
      'Our roofing contractor handles repairs, re-roofing, flat roof '
      'installations, and gutter replacements. We use durable, '
      'weather-resistant materials and provide a full inspection report '
      'with photographic evidence before and after every job.',
    _ =>
      'Our certified professional will arrive at your home fully equipped '
      'to diagnose and resolve the issue efficiently. We use only '
      'high-quality materials and follow industry safety standards to '
      'ensure lasting results and your complete satisfaction.',
  };
}

/// Returns real bullet-point highlights tailored to the given service key.
List<String> serviceHighlights(String serviceKey) {
  return switch (serviceKey.toLowerCase()) {
    'plumbing' => const [
        'Licensed plumber with Gas Safe registration',
        'Drain unblocking and CCTV drain surveys',
        'Emergency call-out available 24 / 7',
        'All pipework pressure-tested after repair',
        'Fully insured — up to \$2M public liability',
      ],
    'electrical' => const [
        'Part P certified — all work self-certified',
        'EV charger and solar panel installations',
        'Smart home and automation wiring',
        'EICR electrical safety certificates issued',
        'Emergency fault-finding within 2 hours',
      ],
    'carpentry' => const [
        'Bespoke fitted furniture made to measure',
        'Structural timber repairs and loft conversions',
        'Period property restoration specialist',
        'Free design consultation and quote',
        'All timber sourced from sustainable suppliers',
      ],
    'cleaning' => const [
        'End-of-tenancy and move-in deep cleans',
        'Eco-friendly, child and pet-safe products',
        'Oven, fridge, and appliance deep cleaning',
        'Carpet and upholstery steam cleaning',
        'Satisfaction guarantee — free re-clean if needed',
      ],
    'appliance repair' => const [
        'All major brands serviced and repaired',
        'Genuine OEM spare parts used',
        'No fix, no fee policy',
        '12-month parts and labour warranty',
        'Same-day repair for most common faults',
      ],
    'painting' => const [
        'Interior and exterior painting and decorating',
        'Wallpaper hanging and removal',
        'Colour consultation service available',
        'Premium paints — Dulux, Farrow & Ball, Little Greene',
        'Dust sheets and full protection of your furniture',
      ],
    'landscaping' => const [
        'Full garden design and landscaping service',
        'Lawn seeding, turfing, and scarification',
        'Irrigation system installation and maintenance',
        'Seasonal planting and bulb schemes',
        'Waste removal and composting included',
      ],
    'pest control' => const [
        'Treatments for rats, mice, cockroaches, and ants',
        'Bed bug heat treatment available',
        'Child and pet-safe chemical applications',
        'Follow-up visit included in every treatment',
        'Proofing and prevention advice provided',
      ],
    'hvac' => const [
        'Gas Safe registered heating engineer',
        'Annual boiler service and safety check',
        'Air conditioning installation and regas',
        'Smart thermostat installation and setup',
        'Emergency breakdown cover available',
      ],
    'roofing' => const [
        'Flat and pitched roof repairs and replacements',
        'Velux window and skylight installation',
        'Lead flashing and chimney repointing',
        'Full scaffold erected for safe access',
        '10-year workmanship guarantee on new roofs',
      ],
    _ => const [
        'Licensed and fully insured professional',
        'Same-day and emergency appointments available',
        'Transparent pricing with no hidden charges',
        'Work guaranteed — free re-visit if issue persists',
        'Clean worksite — we tidy up after every job',
      ],
  };
}
