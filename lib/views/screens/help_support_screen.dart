import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/support/support_contact_item.dart';
import '../widgets/support/faq_item.dart';

/// Help & Support screen.
/// Only Email Support — tapping opens the device Gmail / mail app
/// pre-filled with the company support address, subject and body.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // ── Company support email ─────────────────────────────────────────────────
  static const _supportEmail = 'support@homivo.app';

  // ── FAQs ──────────────────────────────────────────────────────────────────
  static const _faqs = [
    _FaqData(
      question: 'How do I book a service?',
      answer:
          'Tap any service on the Home screen, browse available professionals, '
          'select one and tap "Book Now". Choose your preferred date and time, '
          'add any notes, then confirm your booking.',
    ),
    _FaqData(
      question: 'Can I cancel or reschedule a booking?',
      answer:
          'Yes. Go to My Bookings → tap the booking → select "Cancel" or '
          '"Reschedule". Cancellations made more than 2 hours before the '
          'scheduled time are free of charge.',
    ),
    _FaqData(
      question: 'How are service providers verified?',
      answer:
          'Every provider on Homivo goes through identity verification, '
          'background checks, and skill assessments before being listed.',
    ),
    _FaqData(
      question: 'What payment methods are accepted?',
      answer:
          'We accept all major credit/debit cards, mobile wallets, and '
          'bank transfers. Payment is only charged after the service is '
          'completed and you confirm satisfaction.',
    ),
    _FaqData(
      question: 'What if I am not satisfied with the service?',
      answer:
          'Your satisfaction is guaranteed. If you are not happy, contact '
          'us within 24 hours of service completion and we will arrange a '
          'free re-visit or a full refund.',
    ),
    _FaqData(
      question: 'How do I track my service provider?',
      answer:
          'Once a provider accepts your booking, you can track their live '
          'location on the map from the Active Bookings section. You will '
          'also receive real-time status updates.',
    ),
  ];

  // ── Open Gmail / mail app ─────────────────────────────────────────────────
  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'Homivo Support Request',
        'body':
            'Hello Homivo Support Team,\n\n'
            'I need help with:\n\n'
            '(Please describe your issue here)\n\n'
            'Thank you.',
      },
    );

    final canOpen = await canLaunchUrl(uri);

    // Guard context use after async gap
    if (!context.mounted) return;

    if (canOpen) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No email app found. Please email us at $_supportEmail',
          ),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: _SupportAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero banner ──────────────────────────────────────────────
            const _HeroBanner(),

            const SizedBox(height: 28),

            // ── Contact Us — Email only ───────────────────────────────────
            const _SectionTitle(title: 'Contact Us'),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SupportContactItem(
                  icon:        Icons.email_outlined,
                  title:       'Email Support',
                  subtitle:    _supportEmail,
                  iconColor:   const Color(0xFFEA4335),
                  iconBgColor: const Color(0xFFFEE2E2),
                  showDivider: false,
                  onTap:       () => _openEmail(context),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Tap-to-copy hint ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Tap to open your email app — we reply within 2 hours.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textGrey,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── FAQ section ──────────────────────────────────────────────
            const _SectionTitle(title: 'Frequently Asked Questions'),
            const SizedBox(height: 12),

            ...(_faqs.map(
              (f) => FaqItem(question: f.question, answer: f.answer),
            )),

            const SizedBox(height: 20),

            // ── Support hours footer ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      color: AppTheme.primary, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Support hours: Mon – Sat, 9:00 AM – 6:00 PM.\n'
                      'We typically respond within 2 hours.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryDark,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero banner ───────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How can we help?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Our support team is ready to assist you with any questions or issues.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _SupportAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                  color: const Color(0xFFE8E8E8), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ),
      title: const Text(
        'Help & Support',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF0F0F0)),
      ),
    );
  }
}

// ── FAQ data ──────────────────────────────────────────────────────────────────
class _FaqData {
  final String question;
  final String answer;
  const _FaqData({required this.question, required this.answer});
}
