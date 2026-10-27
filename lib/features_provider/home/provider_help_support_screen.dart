import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../views/widgets/support/support_contact_item.dart';
import '../../views/widgets/support/provider_faq_item.dart';

/// Help & Support screen for the service provider side.
///
/// Contact method: Email only — tapping opens the device Gmail / mail app
/// pre-filled with the provider support address, subject and body.
///
/// Branded with deep-purple accent to match the provider theme.
class ProviderHelpSupportScreen extends StatelessWidget {
  const ProviderHelpSupportScreen({super.key});

  // ── Provider support email ────────────────────────────────────────────────
  static const _supportEmail = 'providers@homivo.app';

  // ── Provider-specific FAQs ────────────────────────────────────────────────
  static const _faqs = [
    _FaqData(
      question: 'How do I receive job requests?',
      answer:
          'Once your profile is verified and you are set to Online, clients '
          'in your service area can send you job requests. You will receive '
          'a push notification and can accept or decline from the Home tab.',
    ),
    _FaqData(
      question: 'How and when do I get paid?',
      answer:
          'Payments are processed automatically after a job is marked as '
          'completed and the client confirms satisfaction. Funds are credited '
          'to your linked wallet within 24 hours. You can withdraw anytime '
          'from the Dashboard → Earnings section.',
    ),
    _FaqData(
      question: 'What happens if a client cancels a booking?',
      answer:
          'If a client cancels more than 2 hours before the scheduled time, '
          'no penalty applies. For late cancellations (under 2 hours), you '
          'are entitled to a 50% cancellation fee which is credited to your '
          'wallet automatically.',
    ),
    _FaqData(
      question: 'How do I update my city or service?',
      answer:
          'Go to Profile → Edit Profile. You can update your '
          'City and Service at any time. Changes take effect immediately '
          'and will be reflected in client search results.',
    ),
    _FaqData(
      question: 'Why is my account being verified?',
      answer:
          'New provider accounts go through a verification process that '
          'includes identity checks and skill assessments. This typically '
          'takes 24–48 hours. You will receive an email once your account '
          'is approved and visible to clients.',
    ),
    _FaqData(
      question: 'What should I do if a client is unresponsive?',
      answer:
          'If a client does not respond within 15 minutes of your arrival, '
          'tap "Client Unresponsive" on the active job card. Our support '
          'team will contact the client on your behalf. You will not be '
          'penalised for no-shows.',
    ),
  ];

  // ── Open Gmail / mail app ─────────────────────────────────────────────────
  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'Homivo Provider Support Request',
        'body':
            'Hello Homivo Provider Support Team,\n\n'
            'I need help with:\n\n'
            '(Please describe your issue here)\n\n'
            'Provider Name: \n'
            'Registered Email: \n\n'
            'Thank you.',
      },
    );

    final canOpen = await canLaunchUrl(uri);

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
            // ── Hero banner ────────────────────────────────────────────
            const _HeroBanner(),

            const SizedBox(height: 28),

            // ── Contact Us — Email only ────────────────────────────────
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
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: _supportEmail,
                  iconColor: const Color(0xFFEA4335),
                  iconBgColor: const Color(0xFFFEE2E2),
                  showDivider: false,
                  onTap: () => _openEmail(context),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Hint ──────────────────────────────────────────────────
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

            // ── FAQ section ────────────────────────────────────────────
            const _SectionTitle(title: 'Frequently Asked Questions'),
            const SizedBox(height: 12),

            ...(_faqs.map(
              (f) => ProviderFaqItem(question: f.question, answer: f.answer),
            )),

            const SizedBox(height: 20),

            // ── Support hours footer ───────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.deepPurpleLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: AppTheme.deepPurple,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Provider support hours: Mon – Sat, 9:00 AM – 6:00 PM.\n'
                      'We typically respond within 2 hours.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.deepPurple,
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
          colors: [AppTheme.deepPurple, Color(0xFF5E35B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepPurple.withValues(alpha: 0.30),
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
                  'Provider Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Have a question about jobs, payments or your account? '
                  'We\'re here to help.',
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
              Icons.handyman_rounded,
              color: Colors.white,
              size: 28,
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
              border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
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

// ── FAQ data model ────────────────────────────────────────────────────────────
class _FaqData {
  final String question;
  final String answer;
  const _FaqData({required this.question, required this.answer});
}
